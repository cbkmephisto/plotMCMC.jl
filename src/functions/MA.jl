"""
 * Copyright (c) 2016 Hailin Su, ISU NBCEC
 *
 * This file is part of plotMCMC.
 *
 * plotMCMC is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * plotMCMC is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU General Lesser Public License
 * along with plotMCMC.  If not, see <http://www.gnu.org/licenses/>.
"""

function MA(vec)
    """
    Calculate moving average of a vector and
    return the MA vector
    """
    xsum=zeros(length(vec))
    xma=zeros(length(vec))
    for xi in 1:length(vec)
        if xi!=1
            xsum[xi]=xsum[xi-1]+vec[xi]
            xma[xi]=xsum[xi]/xi
        else
            xsum[xi]=vec[xi]
            xma[xi]=vec[xi]
        end
    end
    return xma
end
