-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Stephen Morgan, Scott Morrison

import .category
import .functor

namespace categories

open categories.functor
open plift -- we first plift propositional equality to Type 0,
open ulift -- then ulift up to Type v

definition {u v} DiscreteCategory ( α : Type u ) : Category.{u v} :=
{
  Obj            := α,
  Hom            := λ X Y, ulift (plift (X = Y)),
  identity       := ♯,
  compose        := ♯,
  left_identity  := ♯,
  right_identity := ♯,
  associativity  := ♯
}

definition {u v} EmptyCategory := DiscreteCategory.{u v} (ulift empty)

definition {u1 v1 u2 v2} EmptyFunctor ( C : Category.{u2 v2} ) : Functor EmptyCategory.{u1 v1} C := ♯

definition {u1 v1 u2 v2} Functor.fromFunction { C : Category.{u1 v1} } { I : Type u2 } ( F : I → C.Obj ) : Functor (DiscreteCategory.{u2 v2} I) C := {
  onObjects     := F,
  onMorphisms   := by tidy, -- TODO why does it break functoriality below if we replace this with ♯?
  identities    := ♯,
  functoriality := ♯
}

end categories
