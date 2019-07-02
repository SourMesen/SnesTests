# dma_irq_test

Validates the number of instructions that run after a manual DMA ($420B write) when an IRQ or NMI occurs during DMA.

Expected results (tested on a NTSC SNES, using a sd2snes):

    IRQ - INC A              $0002
    IRQ - LDA IMM16          $0002
    IRQ - LDA16+INC          $0002
    IRQ - INC+LDA16          $0002
    IRQ - CLI+INC            $0002
    IRQ - SEI+INC            $FFFF
    IRQ - SEI+CLI+INC        $0001
    NMI - INC A              $0002
    NMI - LDA IMM16          $0002
    NMI - CLI+INC            $0001
