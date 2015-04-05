# Yen3's vimrc

You can get more detials [here](http://yen3.github.io/posts/20131109_using-vim-as-a-default-text-editor.html)(Tradtional Chinese)
But the some information in the blog article is out of dated.

## Install

### Linux/ Mac OSX

1. Get the source from git
    
        git clone https://github.com/yen3/vimfiles

2. Change to the folder

        cd vimfiles

3. Create the symbolic links

        ln -s . ~/.vim
        ln -s ~/.vim/vim ~/.vimrc 

4. Install [vim-plug](https://github.com/junegunn/vim-plug)

        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

5. Open vim and type

        :PlugInstall



