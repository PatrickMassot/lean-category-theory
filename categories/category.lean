-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Stephen Morgan, Scott Morrison

import .tactics
import .graphs

open categories.graphs

namespace categories

structure {u v} Category :=
  ( Obj : Type u )
  ( Hom : Obj → Obj → Type v )
  ( identity : Π X : Obj, Hom X X )
  ( compose  : Π { X Y Z : Obj }, Hom X Y → Hom Y Z → Hom X Z )

  ( left_identity  : ∀ { X Y : Obj } (f : Hom X Y), compose (identity X) f = f )
  ( right_identity : ∀ { X Y : Obj } (f : Hom X Y), compose f (identity Y) = f )
  ( associativity  : ∀ { W X Y Z : Obj } (f : Hom W X) (g : Hom X Y) (h : Hom Y Z),
    compose (compose f g) h = compose f (compose g h) )

attribute [simp] Category.left_identity
attribute [simp] Category.right_identity
attribute [simp,ematch] Category.associativity
attribute [applicable] Category.identity

@[tidy] meta def rewrite_associativity_backwards : tactic string := 
(`[repeat_at_least_once { rewrite ← Category.associativity }])   
  >> `[simp]
  >> tactic.done
  >> pure "repeat_at_least_once {rewrite ← Category.associativity}, simp" 

-- instance Category_to_Hom : has_coe_to_fun Category :=
-- { F   := λ C, C.Obj → C.Obj → Type v,
--   coe := Category.Hom }

definition Category.graph ( C : Category ) : Graph := 
{
  Obj := C.Obj,
  Hom := C.Hom
}

@[ematch] lemma Category.identity_idempotent
  ( C : Category )
  ( X : C.Obj ) : C.identity X = C.compose (C.identity X) (C.identity X) := ♮

open Category

inductive {u v} morphism_path { C : Category.{u v} } : C.Obj → C.Obj → Type (max u v)
| nil  : Π ( h : C.Obj ), morphism_path h h
| cons : Π { h s t : C.Obj } ( e : C.Hom h s ) ( l : morphism_path s t ), morphism_path h t

notation a :: b := morphism_path.cons a b
notation `c[` l:(foldr `, ` (h t, morphism_path.cons h t) morphism_path.nil _ `]`) := l

definition {u v} concatenate_paths
 { C : Category.{u v} } :
 Π { x y z : C.Obj }, morphism_path x y → morphism_path y z → morphism_path x z
| ._ ._ _ (morphism_path.nil _)               q := q
| ._ ._ _ (@morphism_path.cons ._ _ _ _ e p') q := morphism_path.cons e (concatenate_paths p' q)

definition {u v} Category.compose_path ( C : Category.{u v} ) : Π { X Y : C.Obj }, morphism_path X Y → C.Hom X Y
| X ._  (morphism_path.nil ._)                := C.identity X
| _ _   (@morphism_path.cons ._ ._ _ ._ e p)  := C.compose e (Category.compose_path p)

end categories
