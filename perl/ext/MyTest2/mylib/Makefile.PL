use ExtUtils::MakeMaker;
$Verbose = 1;
WriteMakefile(
    NAME  => 'MyTest2::mylib',
    SKIP  => [qw(all static static_lib dynamic dynamic_lib)],
    clean => { FILES => 'libmyblib$(LIB_EXT)' },
);

sub MY::top_targets {
    '
all :: static

pure_all :: static

static :: libmylib$(LIB_EXT)

libmylib$(LIB_EXT): $(O_FILES)
	$(AR) cr libmylib$(LIB_EXT) $(O_FILES)
	$(RANLIB) libmylib$(LIB_EXT)
';
}
