#2) Pattern Matching / "распаковка"

a = 10 #assertion #'a' тут называют pattern
# match operator / a операция '=' называеться pattern matching
10 = a #10
20 = a #error - MatchError

t = {1, 2, 3}
{a, b, c} = t #{1, 2, 3} или a=1,b=2,c=3
{a, _, c} = t #{1, 2, 3} или a=1,c=3
{a, b, c, _} = t #error - MatchError

data = {"Jane", 30, "developer"}
{"Jane", age, position} = data
#{"Jane", 30, "developer"} или age=30, position="developer"

data = {"Bob", 30, "developer"}
{"Jane", age, position} = data #error - MatchError

name = "Jane"
data = {"Jane", 30, "developer"}
{^name, age, position} = data     # оператор '^' / pin
#если name="Jane" то age=30,position="dev"
#НО если (там в 'data') "Bob" то ERROR - MatchError

t = {42, 42, 10}
{a, a, b} = t #ok

list = [1, "dog", 3]
[a, b, c] = list
#[1, "dog", 3] или a=1,b="dog",c=3

nested = [1, [2, 3], 4]
[_, [a, b], _] = nested
#[1, [2, 3], 4] или a=2,b=3

m = %{animal: "cat", age: 5, name: "Mr.Buttons"}
%{animal: animal, age: age, name: name} = m
#... или animal="cat",age=5,name="Mr.Buttons"

%{name: name} = m #ok (можно отдельн элементы Dict)

#=================
a = 10

a = 10 = c #error
{a,b} = {1, 2, 3} #error
{a, b, _} = {1, 2, 3} #ok
{a, _, _} = {1, 2, 3} #ok
{a, b, c} = {1, 2, 3} #ok
[1, [a, _], a] = [1, [2, 3], 2] #ok
{age, name} = %{animal: "cat", age: 5, name: "Mr.Buttons"} #error
