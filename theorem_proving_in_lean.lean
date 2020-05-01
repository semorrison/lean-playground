-- https://leanprover.github.io/theorem_proving_in_lean/

-- 1.3. About this Book

-- Structural Proof
lemma add_commutative₁ (p q : Prop) :
p ∧ q → q ∧ p :=
assume hpq : p ∧ q,
have hp : p, from and.left hpq,
have hq : q, from and.right hpq,
show q ∧ p, from and.intro hq hp

-- Tatical Proof
lemma add_commutative₂ (p q : Prop) :
p ∧ q → q ∧ p :=
begin
intro hpq,
apply and.intro,
{
    exact and.right hpq,
},
{
    exact and.left hpq
}
end

theorem add_commutative :
∀ (p q : Prop), p ∧ q → q ∧ p :=
begin
intros p q,
-- apply add_commutative₁
apply add_commutative₂
end

-- 2.1. Simple Type Theory

constant m : nat
constant n : ℕ
constant z : ℤ

#check m
#check n
#check m + n
#check m * (n + 0)
#check z * (-1)

constants b1 b2 : bool

#check b1           
#check b1 && b2
#check b1 || b2     
#check tt
#check ff
#eval tt && ff
#eval tt || ff

constant f₀ : nat → nat           
constant f₀' : nat -> nat         
constant f₀'' : ℕ → ℕ             
constant p₀ : nat × nat           
constant q₀ : prod nat nat        
constant g₀ : nat → nat → nat
constant g₀' : nat → (nat → nat)  
constant h₀ : nat × nat → nat

constant Fun : (nat → nat) → nat   -- a "functional"

#check f₀        
#check f₀ n      
#check g₀ m n    
#check g₀ m      
#check (m, n)   
#check p₀.1      
#check p₀.2      
#check (m, n).1 
#check (p₀.1, n) 
#check Fun f₀ 

-- 2.2. Types as Objects

#check nat               
#check bool              
#check nat → bool        
#check nat × bool        
#check nat → nat         
#check nat × nat → nat
#check nat → nat → nat
#check nat → (nat → nat)
#check nat → nat → bool
#check (nat → nat) → nat

#check Prop -- Type
#check Prop → Prop -- Type

constants α β γ: Type
constant F : Type → Type
constant G : Type → Type → Type

#check α        
#check F α      
#check F nat    
#check G α
#check G α β    
#check G α nat  

#check @prod
#check prod α β    
#check prod nat nat

#check list α  
#check list nat

#check Type     -- Type : Type 1
#check Type 1   -- Type 1 : Type 2
#check Type 2   -- Type 2 : Type 3
#check Type 3   -- Type 3 : Type 4
#check Type 4   -- Type 4 : Type 5

#check Sort     -- Prop : Type
#check Sort 1   -- Type : Type 1
#check Sort 2   -- Type 1 : Type 2
#check Sort 3   -- Type 2 : Type 3
#check Sort 4   -- Type 3 : Type 4

universe u

-- #check u     -- unknown identifier 'u'
#check Sort u   -- Sort u : Type u
#check Type u   -- Type u : Type (u+1)

constant instance_sort_u : Sort u

#check instance_sort_u -- instance_u : Sort u_1

constant instance_type_u : Type u

#check instance_type_u -- instance_type_u : Type u_1

constant instance_type_u₂ : Type u

#check instance_type_u₂ -- instance_type_u₂ : Type u_1

-- 2.3. Function Abstraction and Evaluation

#check fun x : nat, x + 5
#check λ x : nat, x + 5

#eval (λ x : nat, x + 5) 3 -- 8

constants α₁ α₂ : α
constants β₁ β₂: β

constant f : α → α
constant g : α → β
constant h : α → β → α
constant j : β → γ
constant p : α → α → bool

#check fun x : α, f x                      -- α → α
#check λ x : α, f x                        -- α → α
#check λ x : α, f (f x)                    -- α → α
#check λ x : α, h x β₁                     -- α → α
#check λ y : β, h α₁ y                     -- β → α
#check λ x : α, p (f (f x)) (h (f α₁) β₂)  -- α → bool
#check λ x : α, λ y : β, h (f x) y         -- α → β → α
#check λ (x : α) (y : β), h (f x) y        -- α → β → α
#check λ x y, h (f x) y                    -- α → β → α

constants (a : α) (b : β)

#check a
#check b

#check λ x : α, x        -- α → α
#check λ x : α, b        -- α → β
#check λ x : α, g (f x)  -- α → γ
#check λ x, g (f x)

#check λ b : β, λ x : α, x     -- β → α → α
#check λ (b : β) (x : α), x    -- β → α → α
#check λ (g : β → γ) (f : α → β) (x : α), g (f x)
                              -- (β → γ) → (α → β) → α → γ

#check λ (α β : Type) (b : β) (x : α), x
#check λ (α β γ : Type) (g : β → γ) (f : α → β) (x : α), g (f x)

#check (λ x : α, x) a                    -- α
#check (λ x : α, b) a                    -- β
#check (λ x : α, b) (h a b)              -- β
#check (λ x : α, g (f x)) (h (h a b) b)  -- β

#reduce (λ x : α, x) a                   -- a
#reduce (λ x : α, b) a                   -- b
#reduce (λ x : α, b) (h a b)             -- b
#reduce (λ x : α, g (f x)) (h (h a b) b) -- g (f (h (h a b) b))

#reduce (λ (Q R S : Type) (v : R → S) (u : Q → R) (x : Q),
       v (u x)) α β γ j g a              -- j (g a)

#print "reducing pairs"
#reduce (m, n).1        -- m
#reduce (m, n).2        -- n

#print "reducing boolean expressions"
#reduce tt && ff        -- ff
#reduce ff && b1        -- ff
#reduce b1 && ff        -- b1 && ff

#print "reducing arithmetic expressions"
#reduce n + 0           -- n
#reduce n + 2           -- nat.succ (nat.succ n)
#reduce 2 + 3           -- 5

-- #reduce 12345 * 54321   -- deep recursion was detected at 'replace' (potential solution: increase stack space in your system)
#eval 12345 * 54321

-- 2.4. Introducing Definitions

-- def `def_name` : `type` := `definition`

def foo : (ℕ → ℕ) → ℕ := λ f, f 0

#check foo
#print foo

def foo' := λ f : ℕ → ℕ, f 0

#check foo'
#print foo'

def double (x : ℕ) : ℕ := x + x
-- is equivalent to
def double' : ℕ → ℕ := λ x : ℕ, x + x

#print double
#check double 3
#reduce double 3                 -- 6
#reduce (double 3) - (double' 3) -- 0

def curry (α β γ : Type) (f : α × β → γ) : α → β → γ := sorry
def uncurry (α β γ : Type) (f : α → β → γ) : α × β → γ := sorry

-- 2.5. Local Definitions

#check let y := 2 + 2 in y * y     -- ℕ
#reduce  let y := 2 + 2 in y * y   -- 16

def double_and_square (x : ℕ) : ℕ :=
let y := x + x in y * y

#reduce double_and_square 2   -- 16

#check   let y := 2 + 2, z := y + y in z * z   -- ℕ
#reduce  let y := 2 + 2, z := y + y in z * z   -- 64

def foobar := let a := nat in λ x : a, x + 2

-- def foobar' := (λ a, λ x : a, x + 2) nat   -- error

-- 2.6. Variables and Sections

section var
    variables (α β γ : Type)
    variables (g : β → γ) (f : α → β) (h : α → α)
    variable x : α

    def compose := g (f x)
    def do_twice := h (h x)
    def do_thrice := h (h (h x))

    #print compose
    #print do_twice
    #print do_thrice
end var

-- 2.7. Namespaces

namespace foo
  def a_number : ℕ := 5
  def function (x : ℕ) : ℕ := x + 7

  def fa : ℕ := function a_number
  def ffa : ℕ := function (function a_number)

  def some_name_only_inside_foo : ℕ := 42

  #print "inside foo"

  #check a_number
  #check function
  #check fa
  #check ffa
  #check foo.fa
end foo

#print "outside the namespace"

-- #check some_name_only_inside_foo -- error
#check foo.some_name_only_inside_foo

#check foo.a_number
#check foo.function
#check foo.fa
#check foo.ffa

section
    open foo

    #print "opened foo"

    #check a_number
    #check function
    #check fa
    #check foo.fa
end

-- #check a_number -- error

section
    open list

    #check @nil
    #check @cons
    #check @append
end

namespace blah
    def a : ℕ := 5
    def f (x : ℕ) : ℕ := x + 7
    def fa : ℕ := f a

    -- namespaces can be nested
    namespace inner
        def nothing : ℕ := 0
    end inner
end blah

#check blah.a
#check blah.f
#check blah.inner.nothing

-- namespaces can be re-opened

namespace blah
  def ffa : ℕ := f (f a)
end blah

-- 2.8. Dependent Types

-- a Pi type, or dependent function type
-- Π `\Pi`

-- the type Π x : α, β x denotes the type of functions f with the property that, 
-- for each a : α, f a is an element of β a. 

namespace list_pi

    constant list   : Type u → Type u

    constant cons   : Π α : Type u, α → list α → list α
    constant nil    : Π α : Type u, list α
    constant head   : Π α : Type u, list α → α
    constant tail   : Π α : Type u, list α → list α
    constant append : Π α : Type u, list α → list α → list α

end list_pi

namespace vec_pi
    constant vec : Type u → ℕ → Type u

    constant empty : Π α : Type u, vec α 0
    constant empty₁ : ∀ α : Type u, vec α 0

    constant cons :
        Π (α : Type u) (n : ℕ), α → vec α n → vec α (n + 1)
    constant cons₁ :
        ∀ (α : Type u) (n : ℕ) (a : α), vec α n → vec α (n + 1)
    constant cons₂ :
        ∀ (α : Type u) (n : ℕ) (a : α) (van : vec α n), vec α (n + 1)

    constant append :
        Π (α : Type u) (n m : ℕ), vec α m → vec α n → vec α (n + m)
    constant append₀ :
        Π (α : Type u) (n m : ℕ) (van : vec α n) (vam : vec α m), vec α (n + m)

    -- They are equivalent
    #check cons
    #check cons₁
    #check cons₂

    -- They are equivalent
    #check append
    #check append₀
end vec_pi

-- Sigma types a.k.a dependent products

-- Pi types Π x : α, β x generalize the notion of 
-- a function type α → β by allowing β to depend on α

-- Sigma types Σ x : α, β x generalize the cartesian product α × β
-- in the same way:
-- in the expression sigma.mk a b, 
-- the type of the second element of the pair, b : β a, 
-- depends on the first element of the pair, a : α.

namespace sigma_type
    variable α : Type
    variable β : α → Type
    variable a : α
    variable b : β a

    #check sigma.mk a b      -- ⟨a, b⟩ : Σ (a : α), β a
    #check (sigma.mk a b).1  -- ⟨a, b⟩.fst : α
    #check (sigma.mk a b).2  -- β (sigma.fst (sigma.mk a b))
    -- ⟨a, b⟩.snd : (λ (a : α), β a) ⟨a, b⟩.fst

    #reduce  (sigma.mk a b).1  -- a
    #reduce  (sigma.mk a b).2  -- b
end sigma_type

-- 2.9. Implicit Arguments

namespace implicit_arguments 
    constant list : Type u → Type u

    namespace listish
        constant cons   : Π α : Type u, α → list α → list α
        constant nil    : Π α : Type u, list α
        constant append : Π α : Type u, list α → list α → list α

        -- Lean allows us to specify that this argument should, 
        -- by default, be left implicit.
        -- This is done by putting the arguments in curly braces
        constant consᵢ   : Π {α : Type u}, α → list α → list α
        constant nilᵢ    : Π {α : Type u}, list α
        constant appendᵢ : Π {α : Type u}, list α → list α → list α   

    end listish

    open listish

    variable  α : Type
    variable  a : α
    variables l1 l2 : list α

    #check cons α a (nil α)
    #check append α (cons α a (nil α)) l1
    #check append α (append α (cons α a (nil α)) l1) l2

    #check cons _ a (nil _)
    #check append _ (cons _ a (nil _)) l1
    #check append _ (append _ (cons _ a (nil _)) l1) l2

    #check consᵢ a nilᵢ
    #check appendᵢ (consᵢ a nilᵢ) l1
    #check appendᵢ (appendᵢ (consᵢ a nilᵢ) l1) l2

    namespace for_def
        def ident {α : Type u} (x : α) := x

        variables γ δ : Type u
        variables (c : γ) (d : δ)

        #check ident      -- ?M_1 → ?M_1
        #check @ident     -- ident : Π {α : Type u_1}, α → α
        #check ident c    -- γ
        #check ident d    -- δ
    end for_def

    namespace for_var
        variable { σ : Type u }
        variable x : σ
        def ident := x

        variables γ δ : Type u
        variables (c : γ) (d : δ)

        #check ident      -- ?M_1 → ?M_1
        #check @ident     -- ident : Π {σ : Type u_1}, σ → σ
        #check ident c    -- γ
        #check ident d    -- δ
    end for_var
end implicit_arguments

-- The process of instantiating these “holes,” or “placeholders,”
-- in a term is often known as elaboration. 

#check (2 : ℤ)

namespace ex_02_01
    def double (x : ℕ) : ℕ := x + x

    def do_twice (f : ℕ → ℕ) (x : ℕ) : ℕ := f (f x)

    def Do_Twice : ((ℕ → ℕ) → (ℕ → ℕ)) → (ℕ → ℕ) → (ℕ → ℕ)
    := λ op f, op (op f)

    #reduce Do_Twice do_twice double 2
    #reduce (pow 2 4) * 2

    example : 
    (Do_Twice do_twice double 2) = (double (double (double (double 2)))) :=
    by refl

end ex_02_01

namespace ex_02_02

    def curry {α β γ : Type} (f : α × β → γ) : α → β → γ :=
    λ a b, f (a, b)

    def uncurry {α β γ : Type} (f : α → β → γ) : α × β → γ :=
    λ ab, f ab.1 ab.2
    -- λ ⟨a, b⟩, f a b

    constant op : α × β → γ
    
    -- #check curry
    -- #check curry op

    lemma curry_uncurry {α β γ : Type} (f : α → β → γ) :
        curry (uncurry f) = f := 
    by refl

    #check (a, b)

    lemma uncurry_curry {α β γ : Type} (f : α × β → γ) :
        uncurry (curry f) = f :=
    -- funext (λ ⟨a, b⟩, rfl)
    begin
        -- simp only [curry, uncurry],
        rewrite curry,
        rewrite uncurry,
        apply funext,
        intro x,
        rewrite prod.mk.eta
    end

end ex_02_02



