# dma_irq_test

Validates the number of instructions that run after a manual DMA ($420B write) when an IRQ or NMI occurs during DMA.

Expected results:

    IRQ - INC A              $0002
    IRQ - LDA IMM8           $0002
    IRQ - LDA16+INC          $0001
    IRQ - INC+LDA16          $0002
    IRQ - CLI+INC            $0001
    IRQ - SEI+INC            $FFFF
    IRQ - SEI+CLI+INC        $0001
    NMI - INC A              $0002
    NMI - LDA IMM16          $0001
    NMI - CLI+INC            $0001
    W16:IRQ - INC A          $0001
    W16:IRQ - LDA IMM8       $0001
    W16:IRQ - LDA16+INC      $0001
    W16:IRQ - INC+LDA16      $0001
    W16:IRQ - CLI+INC        $0001
    W16:IRQ - SEI+INC        $FFFF
    W16:NMI - INC A          $0001
    W16:NMI - LDA IMM16      $0001
    W16:NMI - CLI+INC        $0000

### Changelog ###

June 5 2019:
- Fixed tests incorrectly writing to $420B in 16-bit more, causing a write to $420C and making the results inaccurate.
- Added another set of test that keep the 16-bit write to ensure both scenarios are properly tested.

