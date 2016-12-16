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

# This file is part of my julia code library that was used to make reports
#    for variance component estimation projects   - Hailin Su

function pin_m(T, R, G)
    n=length(R[:,1])
    if(n!=length(R[1,:]) || length(G[:,1])!=length(G[1,:]) || 2*n!=length(G[1,:]) || n!=length(T))
        println("ERROR in pin.m(T, R, G)")
        return
    end

    println("VALUE                      ROW_COL  DESCRIPTION")
    # output h2

    println("==================================================== h2")
    for(i=1:n)
#	k=i*2-1
        @printf("h2 = %3.2f                  %02d       %sd\n", G[i, i]/(G[i, i]+R[i, i]), i, T[i])
        @printf("h2 = %3.2f                  %02d       %sm\n", G[i+n, i+n]/(G[i+n, i+n]+R[i, i]), i, T[i])
    end
    println()

    # output rg and re
    println("==================================================== Rg and Re")
#    for(i=1:n)    # i, j is trait
#        for(j=(i+1):n)
#            ki=i*2-1   # k is index (position) in G of ith trait
#            kj=j*2-1   # k is index (position) in G of ith trait
#            @printf("Rg = % 3.2f, Re = % 3.2f     %02d.%02d    %sd.%sd\n", G[ki, kj]/sqrt(G[ki,ki]*G[kj,kj]), R[i, j]/sqrt(R[i,i]*R[j,j]), ki, kj, T[i], T[j])
#            @printf("Rg = % 3.2f                 %02d.%02d    %sm.%sm\n", G[ki+1, kj+1]/sqrt(G[ki+1,ki+1]*G[kj+1, kj+1]), ki+1, kj+1, T[i], T[j])
#        end
#    end

    for(i=1:n)    # i, j is trait
        for(j=(i+1):n)
            ki=i   # k is index (position) in G of ith trait
            kj=j   # k is index (position) in G of ith trait
            @printf("Rg = % 3.2f, Re = % 3.2f     %02d.%02d    %sd.%sd\n", G[ki, kj]/sqrt(G[ki,ki]*G[kj,kj]), R[i, j]/sqrt(R[i,i]*R[j,j]), ki, kj, T[i], T[j])
            @printf("Rg = % 3.2f                 %02d.%02d    %sm.%sm\n", G[ki+n, kj+n]/sqrt(G[ki+n,ki+n]*G[kj+n, kj+n]), ki+n, kj+n, T[i], T[j])
        end
    end


    println("-----------")
#    for(i=1:n)
#	k=i*2-1
#        @printf("Rg = % 3.2f                 %02d.%02d    %sd.%sm\n", G[k, k+1]/sqrt(G[k,k]*G[k+1, k+1]), k, k+1, T[i], T[i])
#    end
    for(i=1:n)
	k=i
        @printf("Rg = % 3.2f                 %02d.%02d    %sd.%sm\n", G[k, k+n]/sqrt(G[k,k]*G[k+n, k+n]), k, k+n, T[i], T[i])
    end



end


function pin(T, R, G)
    n=length(R[:,1])
    if(n!=length(R[1,:]) || length(G[:,1])!=length(G[1,:]) || n!=length(G[1,:]) || n!=length(T))
        println("ERROR in pin(T, R, G)")
        return
    end

    println("VALUE                      ROW_COL  DESCRIPTION")
    # output h2
    println("==================================================== h2")
    for(i=1:n)
        @printf("h2 = %3.2f                  %02d       %s\n", G[i, i]/(G[i, i]+R[i, i]), i, T[i])
    end
    println()

    # output rg and re
    println("==================================================== Rg and Re")
    for(i=1:n)
        for(j=(i+1):n)
            @printf("Rg = % 3.2f, Re = % 3.2f     %02d.%02d    %s.%s\n",
                     G[i, j]/sqrt(G[i, i]*G[j, j]),
                     R[i, j]/sqrt(R[i, i]*R[j, j]),
                     i, j, T[i], T[j])
        end
    end
    println()
end
