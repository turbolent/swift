// RUN: %swift -enable-optional-lvalues -parse -verify %s

struct S {
  var x: Int = 0
  let y: Int = 0

  mutating func mutateS() {}

  init() {}
}

struct T {
  var mutS: S? = nil
  let immS: S? = nil

  mutating func mutateT() {}

  init() {}
}

var mutT: T?
let immT: T? = nil

mutT?.mutateT()
immT?.mutateT() // expected-error{{only has mutating members}}
mutT?.mutS?.mutateS()
mutT?.immS?.mutateS() // expected-error{{only has mutating members}}
mutT?.mutS?.x++
mutT?.mutS?.y++ // expected-error{{'Int' is not convertible to '@lvalue UInt8'}}

// Prefix operators don't chain
// FIXME: Error message could use work
++mutT?.mutS?.x // expected-error{{cannot invoke '++' with an argument of type '$T6??'}}
++mutT?.mutS?.y // expected-error{{cannot invoke '++' with an argument of type '$T6??'}}

// TODO: assignment operators
mutT? = T()
mutT?.mutS = S()
mutT?.mutS? = S()
mutT?.mutS?.x += 0
_ = mutT?.mutS?.x + 0 // expected-error{{value of optional type 'Int?' not unwrapped}}
mutT?.mutS?.y -= 0 // expected-error{{'Int' is not convertible to '@lvalue UInt8'}}
mutT?.immS = S() // expected-error{{cannot assign}}
mutT?.immS? = S() // expected-error{{cannot assign}}
mutT?.immS?.x += 0 // expected-error{{'Int' is not convertible to '@lvalue UInt8'}}
mutT?.immS?.y -= 0 // expected-error{{'Int' is not convertible to '@lvalue UInt8'}}
