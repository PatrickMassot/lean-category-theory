-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Stephen Morgan, Scott Morrison

open tactic
open smt_tactic

def pointwise_attribute : user_attribute := {
  name := `pointwise,
  descr := "A lemma that proves things are equal using the fact they are pointwise equal."
}

run_cmd attribute.register `pointwise_attribute

def unfoldable_attribute : user_attribute := {
  name := `unfoldable,
  descr := "A definition that may be unfoldable, but hesitantly."
}

run_cmd attribute.register `unfoldable_attribute

/- Try to apply one of the given lemas, it succeeds if one of them succeeds. -/
meta def any_apply : list name → tactic unit
| []      := failed
| (c::cs) := (mk_const c >>= fapply /->> trace ("applying " ++ to_string c)-/) <|> any_apply cs

meta def smt_simp   : tactic unit := using_smt $ intros >> try simp
meta def smt_eblast : tactic unit := using_smt $ intros >> try simp >> try eblast
meta def smt_ematch : tactic unit := using_smt $ intros >> add_lemmas_from_facts >> try ematch

meta def pointwise (and_then : tactic unit) : tactic unit :=
do cs ← attribute.get_instances `pointwise,
   try (seq (any_apply cs) and_then)

-- TODO does this have any effect?
attribute [pointwise] funext

open tactic
open lean.parser
open interactive

namespace tactic.interactive
  meta def force (t : itactic) : tactic unit :=
  do gs ← get_goals,
     t,
     gs' ← get_goals,
     guard (gs ≠ gs') <|> tactic.fail "force tactic failed"

  meta def trace_dunfold ( n : name ) : tactic unit := (force (dunfold [n] [])) -- >> (trace ("unfolding " ++ to_string n)) 

  meta def unfold_at_least_one_with_attribute (attr : parse ident) : tactic unit :=
  do defs ← attribute.get_instances attr,
     list.foldl orelse (tactic.fail "") (list.map trace_dunfold defs)
end tactic.interactive

attribute [unfoldable] cast

meta def unfold_something (and_then : tactic unit) : tactic unit := try ( seq (tactic.interactive.unfold_at_least_one_with_attribute `unfoldable) and_then )

meta def blast  : tactic unit := smt_eblast >> pointwise blast >> unfold_something blast

-- In a timing test on 2017-02-18, I found that using `abstract { blast }` instead of just `blast` resulted in a 5x speed-up!
notation `♮` := by abstract { blast }

@[pointwise] lemma {u v} pair_equality {α : Type u} {β : Type v} { X: α × β }: (X^.fst, X^.snd) = X := begin induction X, blast end
@[pointwise] lemma {u v} pair_equality_1 {α : Type u} {β : Type v} { X: α × β } { A : α } ( p : A = X^.fst ) : (A, X^.snd) = X := begin induction X, blast end
@[pointwise] lemma {u v} pair_equality_2 {α : Type u} {β : Type v} { X: α × β } { B : β } ( p : B = X^.snd ) : (X^.fst, B) = X := begin induction X, blast end
-- But let's not use this last one, as it introduces two goals.
-- @[pointwise] lemma {u v} pair_equality_3 {α : Type u} {β : Type v} { X: α × β } { A : α } ( p : A = X^.fst ) { B : β } ( p : B = X^.snd ) : (A, B) = X := begin induction X, blast end
attribute [pointwise] subtype.eq

@[reducible] def {u} auto_cast {α β : Type u} {h : α = β} (a : α) := cast h a
@[simp] lemma {u} auto_cast_identity {α : Type u} (a : α) : @auto_cast α α (by smt_ematch) a = a := ♮
notation `⟦` p `⟧` := @auto_cast _ _ (by smt_ematch) p
