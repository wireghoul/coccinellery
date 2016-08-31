@initialize:ocaml@
@@

let check file =
  let second = List.nth (Str.split (Str.regexp "linux-next/") file) 1 in
  let doto =
    "/var/julia/linux-next/" ^ (Filename.chop_extension second) ^ ".o" in
  Sys.file_exists doto

@r disable optional_qualifier@
identifier i;
position p;
@@

static struct rtc_class_ops i@p = { ... };

@script:ocaml@
p << r.p;
@@

if not (check (List.hd p).file) then Coccilib.include_match false

@ok@
identifier r.i;
expression e1,e2,e3,e4;
position p;
@@

(
devm_rtc_device_register(e1,e2,&i@p,e3)
|
rtc_device_register(e1,e2,&i@p,e3)
|
platform_device_register_data(e1,e2,e3,&i@p,e4)
)

@bad@
position p != {r.p,ok.p};
identifier r.i;
@@

i@p

@depends on !bad disable optional_qualifier@
identifier r.i;
@@

static
+const
 struct rtc_class_ops i = { ... };
