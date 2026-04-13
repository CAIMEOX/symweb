///|
priv enum DocPackage {
  SymSimplify
  SymCalculus
  SymIntegrals
  SymSeries
  SymAssume
  SymLogic
  SymSets
  SymConcrete
  SymDiscrete
  SymMatrices
  SymPolys
  SymNTheory
  SymPhysics
  SymSolvers
} derive(Eq)

///|
priv enum DocFunction {
  Simplify
  TrigSimp
  RatSimp
  Diff
  Periodicity
  Singularities
  Integrate
  LaplaceTransform
  InverseLaplaceTransform
  SeriesExpand
  Limit
  Residue
  AssumeIsInteger
  AssumeIsReal
  AssumeIsPositive
  LogicSimplify
  LogicToCnf
  LogicToDnf
  LogicSatisfiable
  SetInterval
  SetFinite
  SetContains
  Summation
  Product
  Rationalize
  DiscreteFFT
  DiscreteIFFT
  DiscreteFWHT
  DiscreteMobius
  MatrixConstruct
  MatrixEye
  MatrixZeros
  MatrixOnes
  MatrixDet
  MatrixTrace
  MatrixInv
  MatrixRank
  MatrixCharpoly
  MatrixSolve
  TermsGcd
  PolyFactor
  PolyFactorList
  PolySqfPart
  PolySqfList
  PolyCancel
  PolyCompose
  Decompose
  PolyGcd
  PolyDiscriminant
  PolyResultant
  PolyGroebner
  NtIsPrime
  NtFactorInt
  NtTotient
  NtDivisorSigma
  NtMobius
  NtPrimePi
  NtNextPrime
  NtNPartitions
  PhysMsigma
  PhysMgamma
  PhysMdft
  PhysPatMatrix
  PhysDelta
  PhysEpsilon
  PhysPauli
  PhysHydrogenENl
  PhysHydrogenRNl
  PhysHydrogenYlm
  PhysHydrogenZlm
  PhysHydrogenPsiNlm
  PhysWigner3j
  PhysClebschGordan
  PhysGaunt
  PhysRefractionAngle
  PhysBrewsterAngle
  PhysCriticalAngle
  PhysFresnelCoefficients
  PhysJonesVector
  PhysStokesVector
  PhysFreeSpace
  PhysFlatRefraction
  PhysCurvedRefraction
  PhysCurvedMirror
  PhysThinLens
  PhysLinearPolarizer
  PhysPhaseRetarder
  PhysHalfWaveRetarder
  PhysQuarterWaveRetarder
  Solve
  SolveSet
  LinSolve
  NonLinSolve
  Decompogen
} derive(Eq)

///|
priv enum ParserToggle {
  CaretAsPower
  Evaluate
  ImplicitMultiplication
  ImplicitApplication
  FunctionExponentiation
  FactorialNotation
  ConvertEqualsSigns
}

///|
priv enum ThemeMode {
  System
  Light
  Dark
} derive(Eq)

///|
priv struct ParserSettings {
  caret_as_power : Bool
  evaluate : Bool
  implicit_multiplication : Bool
  implicit_application : Bool
  function_exponentiation : Bool
  factorial_notation : Bool
  convert_equals_signs : Bool
}

///|
priv struct ResultField {
  label : String
  value : String
  latex : String?
}

///|
priv struct EvalResult {
  headline : String
  summary : String
  fields : Array[ResultField]
}

///|
priv enum EvalState {
  Success(EvalResult)
  Failure(String)
}

///|
priv struct FunctionExample {
  id : String
  label : String
  description : String
  source : String
}

///|
priv struct FunctionDoc {
  id : DocFunction
  package_id : DocPackage
  label : String
  module_path : String
  signature : String
  summary : String
  narrative : String
  interpretation : String
  examples : Array[FunctionExample]
}

///|
priv struct PackageDoc {
  id : DocPackage
  label : String
  overview : String
  architecture : String
  functions : Array[DocFunction]
}

///|
priv struct DocModel {
  active_package : DocPackage
  active_function : DocFunction
  expanded_packages : Array[DocPackage]
  active_example : String
  draft_source : String
  parser : ParserSettings
  theme_mode : ThemeMode
  show_structural_form : Bool
  result : EvalState
  dirty : Bool
  draft_revision : Int
  settings_open : Bool
}

///|
priv enum DocMsg {
  UpdateDraft(String)
  DebouncedRun(Int)
  CheckKernelReady
  OpenSettings
  CloseSettings
  SetThemeMode(ThemeMode)
  ToggleStructuralFormDisplay
  TogglePackageNode(DocPackage)
  SelectPackage(DocPackage)
  SelectFunction(DocFunction)
  SelectExample(String)
  ToggleParser(ParserToggle)
}
