-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

import ..monic
import ..universal.monic

open categories
open categories.initial
open categories.universal
open categories.isomorphism

namespace categories.abelian

-- This is the definition of abelian from Etingof's "Tensor categories"

structure KernelImageCokernelDecomposition { C : Category } [ ZeroObject C ] { X Y : C.Obj } ( f : C.Hom X Y ) :=
  ( kernel                  : Kernel f   )
  ( cokernel                : Cokernel f )
  ( cokernel_of_kernel      : Cokernel (kernel.inclusion)  )
  ( kernel_of_cokernel      : Kernel (cokernel.projection) )
  ( image_well_defined      : Isomorphism C cokernel_of_kernel.coequalizer kernel_of_cokernel.equalizer )
  ( composition_is_morphism : C.compose (C.compose cokernel_of_kernel.projection image_well_defined.morphism) kernel_of_cokernel.inclusion = f )

structure Abelian ( C : Category ) [ ZeroObject C ] := 
  ( decomposition : ∀ { X Y : C.Obj } ( f : C.Hom X Y ), KernelImageCokernelDecomposition f )

-- This is the usual definition

structure Abelian' ( C : Category ) [ ZeroObject C ] :=
  ( kernel   : ∀ { X Y : C.Obj } ( f : C.Hom X Y ), Kernel f   )
  ( cokernel : ∀ { X Y : C.Obj } ( f : C.Hom X Y ), Cokernel f )
  ( monics_are_regular : ∀ { X Y : C.Obj } { f : C.Hom X Y } ( m : Monic f ), RegularMonic f )
  ( epics_are_regular  : ∀ { X Y : C.Obj } { f : C.Hom X Y } ( m : Epic f  ), RegularEpic f  )
  
-- PROJECT show these definitions are equivalent

-- PROJECT define short and long exact sequences, cohomology?

end categories.abelian