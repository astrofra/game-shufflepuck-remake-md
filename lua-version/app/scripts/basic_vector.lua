function addVectors(ax, az, bx, bz)
  return {ax+bx, az+bz}
end

function mulVectorByScalar(ax, az, s)
  return {ax*s, az*s}
end

function getVectorLength(ax, az)
  return math.sqrt(ax*ax+az*az)
end
