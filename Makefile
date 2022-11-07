setup:
	mkdir bin
	mkdir build
	sudo sh installation/mitamae
	sudo sh installation/ruby_cli
install:
	ruby install.rb
	ruby env.rb
rehash:
	ruby env.rb
