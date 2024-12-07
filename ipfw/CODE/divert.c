#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <err.h>

#define DIVERT_PORT 700

int
main(int argc, char *argv[])
{
	int fd, s;
	struct sockaddr_in sin;
	socklen_t sin_len;

	fd = socket(AF_INET, SOCK_RAW, IPPROTO_DIVERT);
	if (fd == -1)
		err(1, "socket");

	memset(&sin, 0, sizeof(sin));
	sin.sin_family = AF_INET;
	sin.sin_port = htons(DIVERT_PORT);
	sin.sin_addr.s_addr = 0;

	sin_len = sizeof(struct sockaddr_in);

	s = bind(fd, (struct sockaddr *) &sin, sin_len);
	if (s == -1)
		err(1, "bind");

	for (;;) {
		ssize_t n;
		char packet[IP_MAXPACKET];
		struct ip *ip;
		struct tcphdr *th;
		int hlen;
		char src[48], dst[48];

		memset(packet, 0, sizeof(packet));
		n = recvfrom(fd, packet, sizeof(packet), 0,
		    (struct sockaddr *) &sin, &sin_len);
		if (n == -1) {
			warn("recvfrom");
			continue;
		}
		if (n < sizeof(struct ip)) {
			warnx("packet is too short");
			continue;
		}

		ip = (struct ip *) packet;
		hlen = ip->ip_hl << 2;
		if (hlen < sizeof(struct ip) || ntohs(ip->ip_len) < hlen ||
		    n < ntohs(ip->ip_len)) {
			warnx("invalid IPv4 packet");
			continue;
		}

		th = (struct tcphdr *) (packet + hlen);

		if (inet_ntop(AF_INET, &ip->ip_src, src,
		    sizeof(src)) == NULL)
			(void)strlcpy(src, "?", sizeof(src));

		if (inet_ntop(AF_INET, &ip->ip_dst, dst,
		    sizeof(dst)) == NULL)
			(void)strlcpy(dst, "?", sizeof(dst));

		printf("%s:%u -> %s:%u\n",
		    src,
		    ntohs(th->th_sport),
		    dst,
		    ntohs(th->th_dport)
		);

		n = sendto(fd, packet, n, 0, (struct sockaddr *) &sin,
		    sin_len);
		if (n == -1)
			warn("sendto");
	}

	return 0;
}
