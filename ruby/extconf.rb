require 'mkmf'
dir_config('csound')
# unless have_library('lib','csoundCreate')
#   puts "missing csnd"
# end
# unless find_library('csnd','csoundCreate','/usr/local/lib')
#   puts "missing csnd"
# end
unless have_header('csound.h')
  puts "missing csound.h"
end
unless have_func('csoundCreate')
  puts "missing csoundCreate"
end
# if find_library('csnd','csoundCreate','/usr/local/lib') and
#    have_header('csound.h')
# then
# end
$LDFLAGS="-DUSE_DOUBLE -lcsound64"
create_makefile("ruby_csound")
