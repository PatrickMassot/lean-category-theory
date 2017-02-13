-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Stephen Morgan, Scott Morrison

import .category
import .functor
import .natural_transformation

open tqft.categories

namespace tqft.categories.universal

structure InitialObject ( C : Category ) :=
  (object : C^.Obj)
  (morphism : ∀ Y : C^.Obj, C^.Hom object Y)
  (uniqueness :  ∀ Y : C^.Obj, ∀ f : C^.Hom object Y, f = morphism Y)

-- TODO define a coercion along `object`

structure is_initial { C : Category } ( X : C^.Obj ) :=
  (morphism : ∀ Y : C^.Obj, C^.Hom X Y)
  (uniqueness :  ∀ Y : C^.Obj, ∀ f : C^.Hom X Y, f = morphism Y)
  

lemma InitialObjects_are_unique { C : Category } ( X Y : InitialObject C ) : Isomorphism C X^.object Y^.object :=
  {
      morphism := X^.morphism Y^.object,
      inverse := Y^.morphism X^.object,
      witness_1 := begin exact sorry end,
      witness_2 := sorry
  }

-- TODO cones, limits

open tqft.categories.functor
open tqft.categories.natural_transformation

definition DiagonalFunctor ( C J : Category ) : Functor C (FunctorCategory J C) :=
{
  onObjects     := λ X: C^.Obj, {
    onObjects     := λ _, X,
    onMorphisms   := λ _ _ _, C^.identity X,
    identities    := ♮,
    functoriality := ♮
  },
  onMorphisms   := λ X Y f, {
    components := λ _, f,
    naturality := ♮
  },
  identities    := ♮,
  functoriality := ♮  
}

-- The elaborator has some trouble understanding what p.2.2 and q.2.2 mean below.
-- Leo suggested the following work-around, at <https://groups.google.com/d/msg/lean-user/8jW4BIUFl24/MOtgbpfqCAAJ>.
local attribute [elab_simple]  sigma.snd

open subtype

-- universe variable u

-- instance elt_of_coercion {α : Type u} {p : α → Prop} : has_coe { x // p x } α :=
--   { coe := elt_of }

definition CommaCategory { A B C : Category} ( S : Functor A C ) ( T : Functor B C ) : Category :=
{
  Obj      := Σ a : A^.Obj, Σ b : B^.Obj, C^.Hom (S a) (T b),
  Hom      := λ p q, { gh : (A^.Hom p.1 q.1) × (B^.Hom p.2.1 q.2.1) // C^.compose (S^.onMorphisms gh.1) q.2.2 = C^.compose p.2.2 (T^.onMorphisms gh.2) },
  identity := λ p, tag (A^.identity p.1, B^.identity p.2.1) ♮,
  compose  := λ p q r f g, tag (A^.compose (elt_of f).1 (elt_of g).1, B^.compose (elt_of f).2 (elt_of g).2)
                 begin
                   blast,
                   rewrite S^.functoriality
                 end,
  left_identity  := sorry,
  right_identity := sorry,
  associativity  := sorry
}

-- TODO then equalizers, etc.

-- TODO ... how to handle dual notions without too much duplication?

end tqft.categories.universal

