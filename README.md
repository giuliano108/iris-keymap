### Custom keymap for an [Iris Keyboard](https://keeb.io/products/iris-keyboard-split-ergonomic-keyboard)

* Start with a [qmk_firmware](https://github.com/qmk/qmk_firmware) checkout in `../qmk_firmware`
* Build the docker container (stolen from [qmk_compiler](https://github.com/qmk/qmk_compiler)):

        docker build -t qmk_compiler .

* Export a `.json` keymap from [https://config.qmk.fm](https://config.qmk.fm)
* Convert it to a base `keymap.c` with:

        perl -pi -e 's/ANY\((LOWER|RAISE|ADJUST)\)/$1/' iris_rev2_layout_mine.json
        docker run \
           -v $PWD/iris_rev2_layout_mine.json:/qmk_compiler_worker/iris_rev2_layout_mine.json \
           -v $PWD/json2keymap.py:/qmk_compiler_worker/json2keymap.py \
           qmk_compiler \
           ./json2keymap.py > keymap.c.converted

* The `fixkeymap.rb` script makes `keymap.c.converted` look more like the [default](https://github.com/qmk/qmk_firmware/blob/master/keyboards/iris/keymaps/default/keymap.c) Iris keymap found in `../qmk_firmware`:

        ./fixkeymap.rb > keymap.c

* Copy the final `keymap.c` over to the `qmk_firmware` source tree:

        cp -va ../qmk_firmware/keyboards/iris/keymaps/default ../qmk_firmware/keyboards/iris/keymaps/mine
        cp -v keymap.c  ../qmk_firmware/keyboards/iris/keymaps/mine

* Build:

        cd ../qmk_firmware
        make iris/rev2:mine
