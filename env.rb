def readFileContent(path)
  File.open(path, mode = "rt"){|file|
    return file.readlines(chomp: true)
  }
end

def getEnvSet()
  recipePathSet = Dir.glob("./cookbooks/*")
    .map { |path| Dir.glob("#{path}/*") }
    .flatten
    .map { |path| path + "/env" }
    .select { |path| File.exist?("#{path}") }
  return recipePathSet
end

def env()
  envSet = getEnvSet
  allEnv = envSet
    .map { |path| readFileContent(path) + [""] }
    .flatten
  File.open(".zshrc", "w") do |envFile|
    allEnv.each { |line| envFile.puts(line) }
  end
end

env()
