if [ "$1" = "-g" ]; then
  RUN_IN_GDB=1
  shift
else
  RUN_IN_GDB=0
fi

MODE=slowdebug
ARCH=$(uname -m)
export JAVA_HOME=../build/linux-${ARCH}-server-${MODE}/images/jdk
rm -f *.ll *.log *.o *.gdbcmd

#TEST_CLASS=TestInvoke
#TEST_METHOD=test_invoke
TEST_CLASS=TestAlloc
TEST_METHOD=test_allocate

## jeandle
OPTIONS="-ea -XX:-UseCompressedOops -Xlog:jeandle=debug -cp classes -XX:+PrintDeoptimizationDetails -Xbatch -Xcomp -XX:-TieredCompilation -XX:+UseJeandleCompiler -XX:CompileCommand=compileonly,${TEST_CLASS}::${TEST_METHOD} -XX:+PrintNMethods -XX:+JeandleDumpIR -XX:+JeandleDumpObjects"

## c2
#OPTIONS="-ea -cp classes -Xbatch -Xcomp -XX:-TieredCompilation -XX:CompileCommand=compileonly,${TEST_CLASS}::${TEST_METHOD} -XX:CompilerDirectivesFile=test_invoke.json"

if [ $RUN_IN_GDB = 0 ]; then
  $JAVA_HOME/bin/java ${OPTIONS} $TEST_CLASS
else
  echo "r ${OPTIONS} ${TEST_CLASS}" > tmp.gdbcmd
  gdb $JAVA_HOME/bin/java -x tmp.gdbcmd
fi

