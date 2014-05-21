#include <ruby.h>
#include <csound.h>
#include <stdio.h>
/* #include </home/ed/src/csound-csound6-git/include/csound.h> */

uintptr_t csThread(void *clientData); 

typedef struct { 
  int result; 
  CSOUND *csound; 
  int PERF_STATUS; 
  void *ThreadID;
} userData;

static void c_free(userData *ud) {
  csoundDestroy(ud->csound);
  free(ud->ThreadID);
}

static VALUE c_alloc(VALUE klass)
{
  /* CSOUND *csnd; */
  userData *ud;
  VALUE rb_csnd;
  ud = (userData *)malloc(sizeof(userData));
  ud->csound = csoundCreate(0);
  ud->PERF_STATUS = 1; 
  rb_csnd = Data_Wrap_Struct(klass, 0, c_free, ud);
  return rb_csnd;
}

static VALUE c_init(VALUE self)
{
  return self;
}

static VALUE c_compile(VALUE self)
{
  /* CSOUND *csnd; */
  userData *ud;
  const char* first = "csound";
  const char* second = "/home/ed/csound/fm/fmbell.csd";
  char* argv[2];
  argv[0] = malloc(strlen(first) + 1);
  argv[1] = malloc(strlen(second) + 1);
  strcpy(argv[0], first);
  strcpy(argv[1], second);
  Data_Get_Struct(self, userData, ud);
  ud->result = csoundCompile(ud->csound, 2, argv);
  free(argv[0]);
  free(argv[1]);
  return self;
}

static VALUE c_perform(VALUE self)
{
  /* CSOUND *csnd; */
  userData *ud;
  VALUE result;
  Data_Get_Struct(self, userData, ud);
  result = csoundPerform(ud->csound);
  return result;
}

static VALUE c_performThread(VALUE self)
{
  userData *ud;
  /* void *ThreadID; */
  Data_Get_Struct(self, userData, ud);
  if (!ud->result) {  
    ud->ThreadID = csoundCreateThread(csThread, (void *)ud); 
  } 
  else { 
    return 1; 
  }
  return Qnil;
}

static VALUE c_printPerfStatus(VALUE self)
{
  userData *ud;
  Data_Get_Struct(self, userData, ud);
  printf("PERF_STATUS: %d\n", ud->PERF_STATUS);
  return Qnil;
}

static VALUE c_destroy(VALUE self)
{
  /* CSOUND *csnd; */
  userData *ud;
  Data_Get_Struct(self, userData, ud);
  csoundDestroy(ud->csound);
  free(ud);
  return Qnil;
}

static VALUE c_end(VALUE self)
{
  userData *ud;
  Data_Get_Struct(self, userData, ud);
  printf("PERF_STATUS: %d\n", ud->PERF_STATUS);
  ud->PERF_STATUS = 0;
  printf("PERF_STATUS: %d\n", ud->PERF_STATUS);
  /* csoundDestroy(ud->csound); */
  /* c_free(ud); */
  return Qnil;
}

static VALUE c_setMessageLevel(VALUE self, VALUE messageLevel)
{
  userData *ud;
  Data_Get_Struct(self, userData, ud);
  csoundSetMessageLevel(ud->csound, NUM2INT(messageLevel));
  return Qnil;
}

VALUE cCsound;

void Init_ruby_csound() {
  cCsound = rb_define_class("Csound", rb_cObject);
  rb_define_alloc_func(cCsound, c_alloc);
  rb_define_method(cCsound, "initialize", c_init, 0);
  rb_define_method(cCsound, "compile", c_compile, 0);
  rb_define_method(cCsound, "perform", c_perform, 0);
  rb_define_method(cCsound, "end", c_end, 0);
  rb_define_method(cCsound, "destroy", c_destroy, 0);
  rb_define_method(cCsound, "setMessageLevel", c_setMessageLevel, 1);
  rb_define_method(cCsound, "printPerfStatus", c_printPerfStatus, 0);
}
