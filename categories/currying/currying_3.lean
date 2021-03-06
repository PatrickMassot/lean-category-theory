-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

-- import .currying_2

-- open categories
-- open categories.isomorphism
-- open categories.functor
-- open categories.equivalence
-- open categories.functor_categories

-- namespace categories.natural_transformation

-- universes u1 v1 u2 v2 u3 v3

-- variable C : Category.{u1 v1}
-- variable D : Category.{u2 v2}
-- variable E : Category.{u3 v3}

-- theorem Currying_for_functors :
--   Equivalence (FunctorCategory C (FunctorCategory D E)) (FunctorCategory (C × D) E) := 
--   {
--     functor := Uncurry_Functors C D E,
--     inverse := Curry_Functors C D E,
--     isomorphism_1 := {
--      morphism  := Curry_Uncurry_to_identity C D E,
--      inverse   := identity_to_Curry_Uncurry C D E,
--      witness_1 := ♯,
--      witness_2 := ♯
--     },
--     isomorphism_2 := {
--      morphism  := Uncurry_Curry_to_identity C D E,
--      inverse   := identity_to_Uncurry_Curry C D E,
--      witness_1 := ♯,                  
--      witness_2 := ♯ 
--     },
--   }

-- end categories.natural_transformation