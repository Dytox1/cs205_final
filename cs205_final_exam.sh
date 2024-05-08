
#!/bin/bash

# This script processes a Pokémon data file to calculate average HP and Attack
# values and outputs a summary in a specific format.

# Check if a file name has been provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <data_file>"
  exit 1
fi

# Assign the file name to a variable
DATA_FILE="$1"

# Validate that the file exists and is readable
if [ ! -f "$DATA_FILE" ] || [ ! -r "$DATA_FILE" ]; then
  echo "Error: File does not exist or cannot be read."
  exit 1
fi

# Use awk to read the file and calculate average values
awk -F'\t' 'BEGIN {
  hp_sum = 0
  attack_sum = 0
  count = 0
}

# Process the header to dynamically find the index of HP and Attack columns
FNR == 1 {
  for (i = 1; i <= NF; i++) {
    if (tolower($i) == "hp") hp_index = i
    if (tolower($i) == "attack") attack_index = i
  }
  if (!hp_index || !attack_index) {
    print "Error: HP or Attack columns not found in the header."
    exit 1
  }
  next
}

NF > 0 {
  hp_sum += $(hp_index)    # Use dynamically found HP column index
  attack_sum += $(attack_index) # Use dynamically found Attack column index
  count++
}

END {
  if (count == 0) {
    print "Error: No data to process."
    exit 1
  }

  # Calculate average values
  avg_hp = hp_sum / count
  avg_attack = attack_sum / count

  # Print the summary in the specified format
  print "===== SUMMARY OF DATA FILE ====="
  print "   File name: " FILENAME
  print "   Total Pokemon: " count
  printf "   Avg. HP: %.2f\n", avg_hp
  printf "   Avg. Attack: %.2f\n", avg_attack
  print "===== END SUMMARY ====="
}' "$DATA_FILE"

