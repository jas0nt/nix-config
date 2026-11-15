{
  const,
  ...
}:
{
  networking.proxy = {
    default = const.http-proxy;
    allProxy = const.socks-proxy;
    noProxy = "127.0.0.1,localhost,internal.domain";
  };

}
