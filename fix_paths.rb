require 'fileutils'

bin_dst = Dir.pwd + '/mc-bin'

new_ext = ''
IO.foreach('mc-bin/etc/mc/mc.ext') do |line|
    line.gsub!(bin_dst, '%var{APPDIR:/tmp}')
    new_ext += line
end
FileUtils.rm_f("mc-bin/etc/mc/mc.ext")
File.open("mc-bin/etc/mc/mc.ext", "w") do |fp|
    fp.write new_ext
end
