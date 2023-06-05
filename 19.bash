#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 2 ]; then
  echo "Two arguments - a pair of natural numbers - are required."
  exit 1
fi

# Read the arguments
num1=$1
num2=$2

# Check if the arguments are natural numbers
re='^[0-9]+$'
if ! [[ $num1 =~ $re ]] || ! [[ $num2 =~ $re ]]; then
  echo "The arguments must be natural numbers."
  exit 1
fi

# Addition
sum=$((num1 + num2))
echo "Sum: $sum"
echo "Sum: $sum" >> results.txt

# Subtraction
diff=$((num1 - num2))
echo "Difference: $diff"
echo "Difference: $diff" >> results.txt

# Multiplication
prod=$((num1 * num2))
echo "Product: $prod"
echo "Product: $prod" >> results.txt

# Division
div=$((num1 / num2))
echo "Quotient: $div"
echo "Quotient: $div" >> results.txt

# Remainder
mod=$((num1 % num2))
echo "Remainder: $mod"
echo "Remainder: $mod" >> results.txt
