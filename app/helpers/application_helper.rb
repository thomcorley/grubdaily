module ApplicationHelper
  def process_entry(string)
    processor = IngredientEntryProcessor.new(string, 1)
    params = processor.params
    puts params

    puts "---------------------------"

    entry = IngredientEntry.create(params)
    puts entry.slice(:quantity, :unit, :size, :ingredient, :modifier)

    entry
  end
end
