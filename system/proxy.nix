{
  const,
  ...
}:
{
  networking = {
    proxy.default = const.http-proxy;
    proxy.allProxy = const.socks-proxy;
    proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

}
