; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s --mattr=+sve -o - | FileCheck %s

target triple = "aarch64-arm-none-eabi"

; a * b + c
define <vscale x 4 x double> @mull_add(<vscale x 4 x double> %a, <vscale x 4 x double> %b, <vscale x 4 x double> %c) {
; CHECK-LABEL: mull_add:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp2 z6.d, z4.d, z5.d
; CHECK-NEXT:    uzp1 z7.d, z0.d, z1.d
; CHECK-NEXT:    uzp2 z0.d, z0.d, z1.d
; CHECK-NEXT:    uzp1 z1.d, z4.d, z5.d
; CHECK-NEXT:    uzp1 z4.d, z2.d, z3.d
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fmla z1.d, p0/m, z4.d, z7.d
; CHECK-NEXT:    uzp2 z2.d, z2.d, z3.d
; CHECK-NEXT:    movprfx z5, z6
; CHECK-NEXT:    fmla z5.d, p0/m, z4.d, z0.d
; CHECK-NEXT:    movprfx z3, z5
; CHECK-NEXT:    fmla z3.d, p0/m, z2.d, z7.d
; CHECK-NEXT:    fmls z1.d, p0/m, z2.d, z0.d
; CHECK-NEXT:    zip1 z0.d, z1.d, z3.d
; CHECK-NEXT:    zip2 z1.d, z1.d, z3.d
; CHECK-NEXT:    ret
entry:
  %strided.vec = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %a)
  %0 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 0
  %1 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 1
  %strided.vec29 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %b)
  %2 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec29, 0
  %3 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec29, 1
  %4 = fmul fast <vscale x 2 x double> %3, %0
  %5 = fmul fast <vscale x 2 x double> %2, %1
  %6 = fadd fast <vscale x 2 x double> %4, %5
  %7 = fmul fast <vscale x 2 x double> %2, %0
  %strided.vec31 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %c)
  %8 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec31, 0
  %9 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec31, 1
  %10 = fadd fast <vscale x 2 x double> %8, %7
  %11 = fmul fast <vscale x 2 x double> %3, %1
  %12 = fsub fast <vscale x 2 x double> %10, %11
  %13 = fadd fast <vscale x 2 x double> %6, %9
  %interleaved.vec = tail call <vscale x 4 x double> @llvm.experimental.vector.interleave2.nxv4f64(<vscale x 2 x double> %12, <vscale x 2 x double> %13)
  ret <vscale x 4 x double> %interleaved.vec
}

; a * b + c * d
define <vscale x 4 x double> @mul_add_mull(<vscale x 4 x double> %a, <vscale x 4 x double> %b, <vscale x 4 x double> %c, <vscale x 4 x double> %d) {
; CHECK-LABEL: mul_add_mull:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp1 z25.d, z0.d, z1.d
; CHECK-NEXT:    uzp2 z0.d, z0.d, z1.d
; CHECK-NEXT:    uzp1 z1.d, z2.d, z3.d
; CHECK-NEXT:    uzp2 z24.d, z2.d, z3.d
; CHECK-NEXT:    fmul z2.d, z1.d, z0.d
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fmla z2.d, p0/m, z24.d, z25.d
; CHECK-NEXT:    uzp2 z3.d, z4.d, z5.d
; CHECK-NEXT:    uzp1 z26.d, z6.d, z7.d
; CHECK-NEXT:    fmul z1.d, z1.d, z25.d
; CHECK-NEXT:    fmul z0.d, z24.d, z0.d
; CHECK-NEXT:    uzp1 z4.d, z4.d, z5.d
; CHECK-NEXT:    uzp2 z5.d, z6.d, z7.d
; CHECK-NEXT:    fmla z1.d, p0/m, z26.d, z4.d
; CHECK-NEXT:    fmla z2.d, p0/m, z26.d, z3.d
; CHECK-NEXT:    fmla z0.d, p0/m, z5.d, z3.d
; CHECK-NEXT:    fmla z2.d, p0/m, z5.d, z4.d
; CHECK-NEXT:    fsub z1.d, z1.d, z0.d
; CHECK-NEXT:    zip1 z0.d, z1.d, z2.d
; CHECK-NEXT:    zip2 z1.d, z1.d, z2.d
; CHECK-NEXT:    ret
entry:
  %strided.vec = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %a)
  %0 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 0
  %1 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 1
  %strided.vec52 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %b)
  %2 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec52, 0
  %3 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec52, 1
  %4 = fmul fast <vscale x 2 x double> %3, %0
  %5 = fmul fast <vscale x 2 x double> %2, %1
  %6 = fmul fast <vscale x 2 x double> %2, %0
  %7 = fmul fast <vscale x 2 x double> %3, %1
  %strided.vec54 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %c)
  %8 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec54, 0
  %9 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec54, 1
  %strided.vec56 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %d)
  %10 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec56, 0
  %11 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec56, 1
  %12 = fmul fast <vscale x 2 x double> %11, %8
  %13 = fmul fast <vscale x 2 x double> %10, %9
  %14 = fmul fast <vscale x 2 x double> %10, %8
  %15 = fmul fast <vscale x 2 x double> %11, %9
  %16 = fadd fast <vscale x 2 x double> %15, %7
  %17 = fadd fast <vscale x 2 x double> %14, %6
  %18 = fsub fast <vscale x 2 x double> %17, %16
  %19 = fadd fast <vscale x 2 x double> %4, %5
  %20 = fadd fast <vscale x 2 x double> %19, %13
  %21 = fadd fast <vscale x 2 x double> %20, %12
  %interleaved.vec = tail call <vscale x 4 x double> @llvm.experimental.vector.interleave2.nxv4f64(<vscale x 2 x double> %18, <vscale x 2 x double> %21)
  ret <vscale x 4 x double> %interleaved.vec
}

; a * b - c * d
define <vscale x 4 x double> @mul_sub_mull(<vscale x 4 x double> %a, <vscale x 4 x double> %b, <vscale x 4 x double> %c, <vscale x 4 x double> %d) {
; CHECK-LABEL: mul_sub_mull:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp1 z25.d, z0.d, z1.d
; CHECK-NEXT:    uzp2 z0.d, z0.d, z1.d
; CHECK-NEXT:    uzp1 z1.d, z2.d, z3.d
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    uzp2 z24.d, z2.d, z3.d
; CHECK-NEXT:    fmul z2.d, z1.d, z0.d
; CHECK-NEXT:    fmul z1.d, z1.d, z25.d
; CHECK-NEXT:    uzp2 z3.d, z4.d, z5.d
; CHECK-NEXT:    uzp1 z4.d, z4.d, z5.d
; CHECK-NEXT:    uzp1 z5.d, z6.d, z7.d
; CHECK-NEXT:    uzp2 z6.d, z6.d, z7.d
; CHECK-NEXT:    fmul z0.d, z24.d, z0.d
; CHECK-NEXT:    fmla z1.d, p0/m, z6.d, z3.d
; CHECK-NEXT:    fmul z3.d, z5.d, z3.d
; CHECK-NEXT:    fmla z0.d, p0/m, z5.d, z4.d
; CHECK-NEXT:    fmla z3.d, p0/m, z6.d, z4.d
; CHECK-NEXT:    fmla z2.d, p0/m, z24.d, z25.d
; CHECK-NEXT:    fsub z1.d, z1.d, z0.d
; CHECK-NEXT:    fsub z2.d, z2.d, z3.d
; CHECK-NEXT:    zip1 z0.d, z1.d, z2.d
; CHECK-NEXT:    zip2 z1.d, z1.d, z2.d
; CHECK-NEXT:    ret
entry:
  %strided.vec = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %a)
  %0 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 0
  %1 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 1
  %strided.vec54 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %b)
  %2 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec54, 0
  %3 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec54, 1
  %4 = fmul fast <vscale x 2 x double> %3, %0
  %5 = fmul fast <vscale x 2 x double> %2, %1
  %6 = fmul fast <vscale x 2 x double> %2, %0
  %7 = fmul fast <vscale x 2 x double> %3, %1
  %strided.vec56 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %c)
  %8 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec56, 0
  %9 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec56, 1
  %strided.vec58 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %d)
  %10 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec58, 0
  %11 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec58, 1
  %12 = fmul fast <vscale x 2 x double> %11, %9
  %13 = fmul fast <vscale x 2 x double> %10, %8
  %14 = fadd fast <vscale x 2 x double> %13, %7
  %15 = fadd fast <vscale x 2 x double> %12, %6
  %16 = fsub fast <vscale x 2 x double> %15, %14
  %17 = fmul fast <vscale x 2 x double> %10, %9
  %18 = fmul fast <vscale x 2 x double> %11, %8
  %19 = fadd fast <vscale x 2 x double> %18, %17
  %20 = fadd fast <vscale x 2 x double> %4, %5
  %21 = fsub fast <vscale x 2 x double> %20, %19
  %interleaved.vec = tail call <vscale x 4 x double> @llvm.experimental.vector.interleave2.nxv4f64(<vscale x 2 x double> %16, <vscale x 2 x double> %21)
  ret <vscale x 4 x double> %interleaved.vec
}

; a * b + conj(c) * d
define <vscale x 4 x double> @mul_conj_mull(<vscale x 4 x double> %a, <vscale x 4 x double> %b, <vscale x 4 x double> %c, <vscale x 4 x double> %d) {
; CHECK-LABEL: mul_conj_mull:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp2 z24.d, z2.d, z3.d
; CHECK-NEXT:    uzp1 z25.d, z0.d, z1.d
; CHECK-NEXT:    uzp2 z0.d, z0.d, z1.d
; CHECK-NEXT:    uzp1 z1.d, z2.d, z3.d
; CHECK-NEXT:    fmul z2.d, z1.d, z0.d
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fmul z0.d, z24.d, z0.d
; CHECK-NEXT:    fmla z2.d, p0/m, z24.d, z25.d
; CHECK-NEXT:    uzp2 z3.d, z4.d, z5.d
; CHECK-NEXT:    uzp1 z4.d, z4.d, z5.d
; CHECK-NEXT:    uzp1 z5.d, z6.d, z7.d
; CHECK-NEXT:    fnmls z0.d, p0/m, z1.d, z25.d
; CHECK-NEXT:    fmla z0.d, p0/m, z5.d, z4.d
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    fmls z1.d, p0/m, z5.d, z3.d
; CHECK-NEXT:    uzp2 z2.d, z6.d, z7.d
; CHECK-NEXT:    fmla z1.d, p0/m, z2.d, z4.d
; CHECK-NEXT:    fmad z3.d, p0/m, z2.d, z0.d
; CHECK-NEXT:    zip1 z0.d, z3.d, z1.d
; CHECK-NEXT:    zip2 z1.d, z3.d, z1.d
; CHECK-NEXT:    ret
entry:
  %strided.vec = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %a)
  %0 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 0
  %1 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 1
  %strided.vec60 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %b)
  %2 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec60, 0
  %3 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec60, 1
  %4 = fmul fast <vscale x 2 x double> %3, %0
  %5 = fmul fast <vscale x 2 x double> %2, %1
  %6 = fmul fast <vscale x 2 x double> %2, %0
  %strided.vec62 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %c)
  %7 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec62, 0
  %8 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec62, 1
  %strided.vec64 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %d)
  %9 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec64, 0
  %10 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec64, 1
  %11 = fmul fast <vscale x 2 x double> %10, %7
  %12 = fmul fast <vscale x 2 x double> %9, %7
  %13 = fmul fast <vscale x 2 x double> %10, %8
  %14 = fmul fast <vscale x 2 x double> %3, %1
  %15 = fsub fast <vscale x 2 x double> %6, %14
  %16 = fadd fast <vscale x 2 x double> %15, %12
  %17 = fadd fast <vscale x 2 x double> %16, %13
  %18 = fadd fast <vscale x 2 x double> %4, %5
  %19 = fmul fast <vscale x 2 x double> %9, %8
  %20 = fsub fast <vscale x 2 x double> %18, %19
  %21 = fadd fast <vscale x 2 x double> %20, %11
  %interleaved.vec = tail call <vscale x 4 x double> @llvm.experimental.vector.interleave2.nxv4f64(<vscale x 2 x double> %17, <vscale x 2 x double> %21)
  ret <vscale x 4 x double> %interleaved.vec
}

; a + b + 1i * c * d
define <vscale x 4 x double> @mul_add_rot_mull(<vscale x 4 x double> %a, <vscale x 4 x double> %b, <vscale x 4 x double> %c, <vscale x 4 x double> %d) {
; CHECK-LABEL: mul_add_rot_mull:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    uzp1 z25.d, z0.d, z1.d
; CHECK-NEXT:    uzp2 z0.d, z0.d, z1.d
; CHECK-NEXT:    uzp1 z1.d, z2.d, z3.d
; CHECK-NEXT:    uzp2 z24.d, z2.d, z3.d
; CHECK-NEXT:    fmul z2.d, z1.d, z0.d
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    fmla z2.d, p0/m, z24.d, z25.d
; CHECK-NEXT:    fmul z0.d, z24.d, z0.d
; CHECK-NEXT:    uzp2 z3.d, z4.d, z5.d
; CHECK-NEXT:    uzp1 z24.d, z6.d, z7.d
; CHECK-NEXT:    uzp1 z4.d, z4.d, z5.d
; CHECK-NEXT:    fmla z0.d, p0/m, z24.d, z3.d
; CHECK-NEXT:    uzp2 z5.d, z6.d, z7.d
; CHECK-NEXT:    fmla z2.d, p0/m, z24.d, z4.d
; CHECK-NEXT:    fmla z0.d, p0/m, z5.d, z4.d
; CHECK-NEXT:    fmls z2.d, p0/m, z5.d, z3.d
; CHECK-NEXT:    fnmsb z1.d, p0/m, z25.d, z0.d
; CHECK-NEXT:    zip1 z0.d, z1.d, z2.d
; CHECK-NEXT:    zip2 z1.d, z1.d, z2.d
; CHECK-NEXT:    ret
entry:
  %strided.vec = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %a)
  %0 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 0
  %1 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec, 1
  %strided.vec80 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %b)
  %2 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec80, 0
  %3 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec80, 1
  %4 = fmul fast <vscale x 2 x double> %3, %0
  %5 = fmul fast <vscale x 2 x double> %2, %1
  %6 = fmul fast <vscale x 2 x double> %2, %0
  %7 = fmul fast <vscale x 2 x double> %3, %1
  %strided.vec82 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %c)
  %8 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec82, 0
  %9 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec82, 1
  %strided.vec84 = tail call { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double> %d)
  %10 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec84, 0
  %11 = extractvalue { <vscale x 2 x double>, <vscale x 2 x double> } %strided.vec84, 1
  %12 = fmul fast <vscale x 2 x double> %10, %8
  %13 = fmul fast <vscale x 2 x double> %10, %9
  %14 = fmul fast <vscale x 2 x double> %11, %8
  %15 = fadd fast <vscale x 2 x double> %13, %7
  %16 = fadd fast <vscale x 2 x double> %15, %14
  %17 = fsub fast <vscale x 2 x double> %6, %16
  %18 = fadd fast <vscale x 2 x double> %4, %5
  %19 = fadd fast <vscale x 2 x double> %18, %12
  %20 = fmul fast <vscale x 2 x double> %11, %9
  %21 = fsub fast <vscale x 2 x double> %19, %20
  %interleaved.vec = tail call <vscale x 4 x double> @llvm.experimental.vector.interleave2.nxv4f64(<vscale x 2 x double> %17, <vscale x 2 x double> %21)
  ret <vscale x 4 x double> %interleaved.vec
}

declare { <vscale x 2 x double>, <vscale x 2 x double> } @llvm.experimental.vector.deinterleave2.nxv4f64(<vscale x 4 x double>)
declare <vscale x 4 x double> @llvm.experimental.vector.interleave2.nxv4f64(<vscale x 2 x double>, <vscale x 2 x double>)
