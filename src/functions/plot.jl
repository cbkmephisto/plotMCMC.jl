function plot_MCMC_Sample(fileName; title="", tr=[], wcm_each=24, hcm_each=8)

	println(" - loading data")
	mtx   = readdlm(fileName)
	n, m  = size(mtx)
	cols  = [colorant"red",
		 colorant"orange",
		 colorant"lightblue",
		 colorant"green",
		 colorant"brown",
		 colorant"blue",
		 colorant"purple"]

	final = compose(context(0, 0, 1w, 1cm),
               	text(0.5, 1.0, title, hcenter, vbottom))

	finalqt = compose(context(0, 0, 1w, 1cm),
               	text(0.5, 1.0, title*" quater burn-in", hcenter, vbottom))

	finalhf = compose(context(0, 0, 1w, 1cm),
               	text(0.5, 1.0, title*" half burn-in", hcenter, vbottom))

	row = 1
	col = 1
	qt = Int(round(n/4,0))

	lx=length(tr)
	blabMatched = (lx+lx^2 == 2*m)
	if !blabMatched
		println("   ERROR: number of trait names given does not match with matrix read. Using default labels for ylab.")
	end

	# posterior mean matrix
	actDim = Int(round(sqrt(2*m+0.25), 0))
	pm0 = zeros(actDim, actDim)
	pmq = zeros(actDim, actDim)
	pmh = zeros(actDim, actDim)

	# for each column in the data, i.e. each element of the lower triangle (co-)v matrix
	for c in 1:m

		if !blabMatched
			rlab="$row"
			clab="$col"
		else
			rlab=tr[col]
			clab=tr[row]
		end

		m0   = round(mean(mtx[:,c]), 2)
		pm0[row,col]=pm0[col,row]=m0
		mqt  = round(mean(mtx[qt+1:end,c]), 2)
		pmq[row,col]=pmq[col,row]=mqt
		mhf  = round(mean(mtx[2*qt+1:end,c]), 2)
		pmh[row,col]=pmh[col,row]=mhf
	
		if row == col
			ylab = "Var($rlab)"
			row += 1
			col = 0
		else
			ylab = "Cov($clab, $rlab)"
		end
		col += 1




		println("    * plotting column $c, posterior mean  = $m0 (0bi), $mqt (qtbi), $mhf (hfbi)")
		pleft  = plot(
				layer(x=1:n, y=MA(mtx[:,c]), Geom.line, Theme(default_color=cols[1+(c+3)%7])),
				layer(x=1:n, y=mtx[:,c], Geom.line, Theme(default_color=cols[1+c%7])),
				Guide.ylabel(ylab),
				Guide.xticks(ticks=collect(0:n/4:n)),
				Guide.xlabel("iteration, posterior mean = $m0 (0bi), $mqt (qtbi), $mhf (hfbi)")
			)

		pright = plot(
				y=mtx[:,c], Geom.histogram(orientation=:horizontal), Theme(default_color=cols[1+c%7]),
				Guide.ylabel(""), Guide.yticks(label=false),
				# Guide.xticks(ticks=collect(0:n/16:n/4)),
				Guide.xlabel("count")
			)

		p      = hstack(compose(context(0, 0, (wcm_each/6*5)cm, (hcm_each)cm), render(pleft)),
				compose(context(0, 0, (wcm_each/6)cm, (hcm_each)cm), render(pright)))

		final  = vstack(final, p)


		# QT BI
		pleft  = plot(
				layer(x=(qt+1):n, y=MA(mtx[(qt+1):n,c]), Geom.line, Theme(default_color=cols[1+(c+3)%7])),
				layer(x=(qt+1):n, y=mtx[(qt+1):n,c], Geom.line, Theme(default_color=cols[1+c%7])),
				Guide.ylabel(ylab),
				Guide.xticks(ticks=collect(qt:n/4:n)),
				Guide.xlabel("iteration, posterior mean = $m0 (0bi), $mqt (qtbi), $mhf (hfbi)")
			)

		pright = plot(
				y=mtx[(qt+1):n,c], Geom.histogram(orientation=:horizontal), Theme(default_color=cols[1+c%7]),
				Guide.ylabel(""), Guide.yticks(label=false),
				# Guide.xticks(ticks=collect(0:n/16:n/4)),
				Guide.xlabel("count")
			)

		p      = hstack(compose(context(0, 0, (wcm_each/6*5)cm, (hcm_each)cm), render(pleft)),
				compose(context(0, 0, (wcm_each/6)cm, (hcm_each)cm), render(pright)))

		finalqt  = vstack(finalqt, p)


		# HF BI
		pleft  = plot(
				layer(x=(qt*2+1):n, y=MA(mtx[(qt*2+1):n,c]), Geom.line, Theme(default_color=cols[1+(c+3)%7])),
				layer(x=(qt*2+1):n, y=mtx[(qt*2+1):n,c], Geom.line, Theme(default_color=cols[1+c%7])),
				Guide.ylabel(ylab),
				Guide.xticks(ticks=collect(qt*2:n/4:n)),
				Guide.xlabel("iteration, posterior mean = $m0 (0bi), $mqt (qtbi), $mhf (hfbi)")
			)

		pright = plot(
				y=mtx[(qt*2+1):n,c], Geom.histogram(orientation=:horizontal), Theme(default_color=cols[1+c%7]),
				Guide.ylabel(""), Guide.yticks(label=false),
				# Guide.xticks(ticks=collect(0:n/16:n/4)),
				Guide.xlabel("count")
			)

		p      = hstack(compose(context(0, 0, (wcm_each/6*5)cm, (hcm_each)cm), render(pleft)),
				compose(context(0, 0, (wcm_each/6)cm, (hcm_each)cm), render(pright)))

		finalhf  = vstack(finalhf, p)

	end
	
	# set_default_plot_size((wcm_each)cm, (1+(hcm_each*m))cm)


	println("\n - Posterior mean 0 burn in:")
	println(pm0)

	println("\n - Posterior mean 1/4 burn in:")
	println(pmq)

	println("\n - Posterior mean 1/2 burn in:")
	println(pmh)
	println("\n")

	draw(PNG("plot.$fileName.png", (wcm_each)cm, (1+(hcm_each*m))cm), final)
	draw(PNG("plot.qt.$fileName.png", (wcm_each)cm, (1+(hcm_each*m))cm), finalqt)
	draw(PNG("plot.hf.$fileName.png", (wcm_each)cm, (1+(hcm_each*m))cm), finalhf)

	draw(SVG("plot.$fileName.svg", (wcm_each)cm, (1+(hcm_each*m))cm), final)
	draw(SVG("plot.qt.$fileName.svg", (wcm_each)cm, (1+(hcm_each*m))cm), finalqt)
	draw(SVG("plot.hf.$fileName.svg", (wcm_each)cm, (1+(hcm_each*m))cm), finalhf)

	println(" - PNG and SVG saved to plot.[qt|hf.]$fileName.png[svg]. \n\n")
	return (pm0, pmq, pmh)
end

