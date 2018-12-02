#!/usr/bin/env ruby

default_keymap_filename = '../qmk_firmware/keyboards/iris/keymaps/default/keymap.c'
converted_keymap_filename = 'keymap.c.converted'

layerno_to_define = {
  '0' => '_QWERTY',
  '1' => '_LOWER',
  '2' => '_RAISE',
  '3' => '_ADJUST',
}
converted_keymap = ''
skip_one = false
File.foreach(converted_keymap_filename) do |line|
  if skip_one
    skip_one = false
    next
  end
  if m = line.match(/(^\s*\[)(\d+)(\].*)/)
    converted_keymap << "#{m[1]}#{layerno_to_define[m[2]]}#{m[3]}\n"
  elsif line.include? '#include QMK_KEYBOARD_H'
    skip_one = true
  else
    converted_keymap << line
  end
end

final_keymap = ''

header_finished = false
header = ''
converted_keymap_included = false
footer_started = false
File.foreach(default_keymap_filename).each do |line|
  if !header_finished
    if line.include? 'const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS]'
      header_finished = true
    else
      final_keymap << line
    end
  end
  if header_finished && !footer_started
    if line.match /^};$/
      footer_started = true
      next
    end
  end
  if footer_started
    if !converted_keymap_included
      final_keymap << converted_keymap
      converted_keymap_included = true
    end
    final_keymap << line
  end
end

puts final_keymap
