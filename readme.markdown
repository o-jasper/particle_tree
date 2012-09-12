
# Electron-positron-photon shower

This will be an approximation, using only Brehmstrahlung and pair production.
Not entirely sure where exactly the approximation starts.

Currently it is probably pretty much wrong due to the soft photon spectrum
not being correct. Nevertheless it does seem like for instance the muon does
radiate less and loses less energy.(though i think it isn't 'less enough')

The scale of spatial sizes is not quite right yet either.

## TODO

* Make soft-photon particles that are also listed, and make `DecayEvent`
  and `InteractEvent` path sections? (better consistency testing.)

* soft photon spectrum thing..

* get spatial scales right

* histogram stuff.

* 'hook-and-move-along' mode so not whole trees have to be simulated and 
  stored in memory and cleared after.
  (wonder how clever julia is in that regard)

* consistency check
