{
  const,
  ...
}:
{
  networking = {
    proxy.default = const.my-http-proxy;
    proxy.allProxy = const.my-socks-proxy;
    proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

}
