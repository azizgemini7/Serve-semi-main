class MathHelper {
  mapNumberRange(double x, double a1, double b1, double a2, double b2) {
    return (x - a1) / (b1 - a1) * (b2 - a2) + a2;
  }
}
