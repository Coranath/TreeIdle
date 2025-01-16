extends Node

const NewBranchMinAngle = 60
const NewBranchMaxAngle = 120
const TotalBranchChance = 10000
const SingleBranchChance = 9990 # Out of 1000
const DoubleBranchChance = 9995
const TripleBranchChance = 10000 
# Confusing as this looks, check sprout function in root, to see how it works.
const MaxNumberOfBranches = 200

const GrowDelay = 0.05

const MaxWidth = Vector2(40,40)
const WidthGrowth = Vector2(0.25, 0.25)
const WidthGrowthDelay = 0.75

var growth = true
