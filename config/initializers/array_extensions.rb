class Array
  def rotate(n)
    len = self.length
    n %= len unless n == 0
    self[len - n, len] + self[0, len - n]
  end
end
