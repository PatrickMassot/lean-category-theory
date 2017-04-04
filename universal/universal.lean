-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Stephen Morgan, Scott Morrison

import .initial
import ..isomorphism
import ..natural_transformation
import ..graph

open tqft.categories
open tqft.categories.functor
open tqft.categories.isomorphism
open tqft.categories.initial

namespace tqft.categories.universal

structure Cone { J C : Category } ( F : Functor J C ) :=
  ( limit : C.Obj )
  ( maps  : Π X : J.Obj, C.Hom limit (F X) )
  ( commutativity : Π X Y : J.Obj, Π f : J.Hom X Y, C.compose (maps X) (F.onMorphisms f) = maps Y )

local attribute [simp,ematch] Cone.commutativity

structure ConeMorphism { J C : Category } { F : Functor J C } ( X Y : Cone F ) :=
  ( morphism : C.Hom X.limit Y.limit )
  ( commutativity : Π P : J.Obj, C.compose morphism (Y.maps P) = (X.maps P) )

local attribute [simp,ematch] ConeMorphism.commutativity

@[pointwise] lemma ConeMorphism_componentwise_equal
  { J C : Category } { F : Functor J C } { X Y : Cone F }
  { f g : ConeMorphism X Y }
  ( w : f.morphism = g.morphism ) : f = g :=
  begin
    induction f,
    induction g,
    blast
  end

definition Cones { J C : Category } ( F : Functor J C ) : Category :=
{
  Obj            := Cone F,
  Hom            := λ X Y, ConeMorphism X Y,
  compose        := λ X Y Z f g, ⟨ C.compose f.morphism g.morphism, ♮ ⟩,
  identity       := λ X, ⟨ C.identity X.limit, ♮ ⟩,
  left_identity  := ♯,
  right_identity := ♯,
  associativity  := ♯
}

structure Cocone { J C : Category } ( F : Functor J C ) :=
  ( colimit : C.Obj )
  ( maps  : Π X : J.Obj, C.Hom (F X) colimit )
  ( commutativity : Π X Y : J.Obj, Π f : J.Hom X Y, C.compose (F.onMorphisms f) (maps Y) = maps X )

local attribute [simp,ematch] Cocone.commutativity

structure CoconeMorphism { J C : Category } { F : Functor J C } ( X Y : Cocone F ) :=
  ( morphism : C.Hom X.colimit Y.colimit )
  ( commutativity : Π P : J.Obj, C.compose (X.maps P) morphism = (Y.maps P) )

local attribute [simp,ematch] CoconeMorphism.commutativity

@[pointwise] lemma CoconeMorphism_componentwise_equal
  { J C : Category } { F : Functor J C } { X Y : Cocone F }
  { f g : CoconeMorphism X Y }
  ( w : f.morphism = g.morphism ) : f = g :=
  begin
    induction f,
    induction g,
    blast
  end

definition Cocones { J C : Category } ( F : Functor J C ) : Category :=
{
  Obj            := Cocone F,
  Hom            := λ X Y, CoconeMorphism X Y,
  compose        := λ X Y Z f g, ⟨ C.compose f.morphism g.morphism, ♮ ⟩,
  identity       := λ X, ⟨ C.identity X.colimit, ♮ ⟩,
  left_identity  := ♯,
  right_identity := ♯,
  associativity  := ♯
}

structure {u} Singleton ( α : Type u ) :=
  ( element : α )
  ( uniqueness : ∀ X Y : α, (X = Y) )

structure Equalizer { C : Category } { X Y : C.Obj } ( f g : C.Hom X Y ) :=
  ( equalizer : C.Obj )
  ( inclusion : C.Hom equalizer X )
  ( witness   : C.compose inclusion f = C.compose inclusion g )
  ( factorisation : ∀ { Z : C.Obj } ( k : C.Hom Z X ) ( w : C.compose k f = C.compose k g ), Singleton { i : C.Hom Z equalizer // (C.compose i inclusion = k) } )

structure Product { C : Category } ( X Y : C.Obj ) :=
  ( product          : C.Obj )
  ( left_projection  : C.Hom product X )
  ( right_projection : C.Hom product Y )
  ( map : ∀ { Z : C.Obj } ( f : C.Hom Z X ) ( g : C.Hom Z Y ), Singleton { i : C.Hom Z product // f = C.compose i left_projection ∧ g = C.compose i right_projection } )

-- definition {u} subtype.val_eq { α : Type u } { P : α → Prop } { X Y : { a : α // P a } } ( h : X = Y ) : X.val = Y.val := ♮

-- definition Product.uniqueness
--   { C : Category } { X Y Z : C.Obj } { p : Product X Y }
--   { f : C.Hom Z X } { g : C.Hom Z Y }
--   { i1 i2 : C.Hom Z p.product }
--   ( w1 : f = C.compose i1 p.left_projection ∧ g = C.compose i1 p.right_projection )
--   ( w2 : f = C.compose i2 p.left_projection ∧ g = C.compose i2 p.right_projection ) : i1 = i2 :=
--   subtype.val_eq ((p.map f g).uniqueness ⟨ i1, ♮ ⟩ ⟨ i2, ♮ ⟩)

structure Coequalizer { C : Category } { X Y : C.Obj } ( f g : C.Hom X Y ) :=
  ( coequalizer : C.Obj )
  ( projection  : C.Hom Y coequalizer )
  ( witness     : C.compose f projection = C.compose g projection )
  ( factorisation : ∀ { Z : C.Obj } ( k : C.Hom Y Z ) ( w : C.compose f k = C.compose g k ), Singleton { p : C.Hom coequalizer Z // (C.compose projection p = k) } )

structure Coproduct { C : Category } ( X Y : C.Obj ) :=
  ( coproduct       : C.Obj )
  ( left_inclusion  : C.Hom X coproduct )
  ( right_inclusion : C.Hom Y coproduct )
  ( map : ∀ { Z : C.Obj } ( f : C.Hom X Z ) ( g : C.Hom Y Z ), Singleton { p : C.Hom coproduct Z // f = C.compose left_inclusion p ∧ g = C.compose right_inclusion p } )

definition {u} unique_up_to_isomorphism ( α : Type u ) { C : Category } ( f : α → C.Obj ) := Π X Y : α, Isomorphism C (f X) (f Y)

class has_InitialObject ( C : Category ) :=
  ( initial_object : InitialObject C )
class has_FiniteProducts ( C : Category ) extends has_InitialObject C :=
  ( binary_product : Π X Y : C^.Obj, Product X Y )

definition product { C : Category } [ has_FiniteProducts C ] ( X Y : C.Obj ) := has_FiniteProducts.binary_product X Y
definition initial_object { C : Category } [ has_FiniteProducts C ] : C.Obj := has_FiniteProducts.initial_object C
-- PROJECT construct finite products from these

end tqft.categories.universal

