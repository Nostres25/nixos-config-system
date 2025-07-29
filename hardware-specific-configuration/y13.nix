{ ... }: {
  
  # Attempt to fix sound on unowhy Y13 laptop (initially a driver issue on windows but on linux it's... different ?)
  # hardware.enableAllFirmware  = true; # useless ?
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';
}