A collection of test roms for the SNES.

* **op_timing_test**: Validates the number of cycles taken by almost all instructions, using all combinations of the X/M flags.
* **dma_irq_test**: Validates the number of instructions that run after a manual DMA ($420B write) when an IRQ or NMI occurs during DMA.
* **timing_test**: WIP - general timing test that attempts to validate rough timings for DMA, HDMA and IRQ/NMIs.
