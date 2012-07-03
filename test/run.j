
vol = Volume(1e6,1, 82,207.2,1)

for n = 1:1
  p = Path(photon, 1e9)
  recursive_transport!(p,vol, 1e5, 100)
  print_gnuplottable(p, stdout_stream)
end