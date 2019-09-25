defmodule DisplayRecipeTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import DisplayRecipe.CLI

  test "print prints a string to stdout" do
    assert capture_io(fn -> DisplayRecipe.CLI.print("Ice Cubes") end) == "Ice Cubes\n"
  end

  test "main prints a welcome message" do
    assert capture_io(fn -> DisplayRecipe.CLI.main("") end) == "Welcome to Recipe Book!\n"
  end

  describe "read_file/1" do
  	test "accepts string filepath and returns string of file contents" do
		example_filepath = "../recipes/ice_cubes.txt"
		assert read_file(example_filepath) == "Title:\nIce Cubes\n\nIngredients:\n2 cups water (approximately)\n2 tablespoons water (additional if needed)\n\nDirections:\n- Empty any ice cubes that are left in the trays into the bin.\n- Take the trays over to the sink and fill them with water. (Tip: hot water will freeze faster and the cubes will be more clear.)\n- Place the water-filled ice trays back in the freezer.\n- Replace the ice bin if you had to remove it.\n- Shut the door to the freezer.\n- Be sure to leave for around 4-6 hours at least to make sure it is frozen.\n"
	end 
  end 

end
