{ ... }:
{
  services.smartd = {
    enable = true;
    autodetect = true;
    # Run short self tests daily, long self tests weekly
    defaults.autodetected = "-a -o on -s (S/../.././02|L/../../7/04)";
  };
}
