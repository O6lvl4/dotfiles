require "tty-prompt"

def selectKindRecipe()
  prompt = TTY::Prompt.new
  kinds = Dir.glob("./cookbooks/*").map { |dir| dir.split("/").last }
  return prompt.select("Which select kind receip?", kinds)
end

def selectRecipes(kind)
  prompt = TTY::Prompt.new
  recipes = Dir.glob("./cookbooks/#{kind}/*").map { |dir| dir.split("/").last }
  p recipes
  return prompt.multi_select("Which select receips?", recipes)
end

def main
  prompt = TTY::Prompt.new
  kind = selectKindRecipe()
  recipes = selectRecipes(kind)
  p recipes
end

main()
