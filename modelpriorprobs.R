priorprobs<- function(k, type="Half-k"){
	#this function is a complement to the package BayesVarSel 
	
	#With this function you can implement the prior model probabilities studied
	#in Berger, García-Donato and Pericchi (2026)
	#specifying --within either Bvs() or GibbsBvs()-- the arguments prior.models="User" 
	#and for the argument priorprobs the result of this function
	
	#Arguments:
	#k: is the number of explanatory variables in the full not counting fixed variables
	#type: can be one of
	#"Half-k"
	#"Half-p"
	#"CGM"
	#"HB"
	#"Harmonic"
	#"Beta(1,2)"
	
	#Requirements: for type="Half-p" the package zipfR is needed
	
	if (type!="Half-k" & type!="Half-p" & type!="CGM" & type!="HB" & type!="Harmonic" & type!="Beta(1,2)") {stop("Model prior not covered.\n")}
	
	if (type == "Half-k") {
		#the case where k is even (par)
		if (round(k/2)==(k/2)) {
			Nk<- sum(choose(k, (1+k/2):k))
			a<- 2*(k+1)/(k); d<- 2*Nk/choose(k, k/2)
			C2<- a/(1+(k+2)/d)
			C1<- 2*(k+1)/(k+2)-C2*k/(k+2)	
			Halfk<-  c(C1*((k+1)*choose(k,0:(k/2)))^(-1), C2*rep(k*(2*(k+1)*Nk)^(-1), k/2))
		}

		#the case where k is odd (impar)
		if (round(k/2)!=(k/2)) {
			Nk<- sum(choose(k, ((1+k)/2):k))
			C2<- (4*Nk)/((k+1)*choose(k, (k-1)/2))/(1+ (2*Nk)/((k+1)*choose(k, (k-1)/2)))
			C1<- 2-C2
			Halfk<-  c(C1*((k+1)*choose(k,0:((k-1)/2)))^(-1), C2*rep((2*Nk)^(-1), (k+1)/2))
		}
		return(Halfk)
	}
	
	if (type == "Half-p") {
		library(zipfR) #for the incomplete Beta
		Upper<- .5*(k+1)/k
		Halfp<- Ibeta(rep(Upper, k+1), (0:k)+1, k+1-(0:k))/Upper
		return(Halfp)		
	}
	
	if (type == "CGM"){
		temp.fun<- function(k){
			f<- function(lambda, k) {
				exp(dpois(lambda=lambda, x=k, log=TRUE)+
				log(cosh(2*sqrt(lambda)))-.5*log(lambda)-lambda-1-log(sqrt(pi)))
			}
			integrate(f, lower=0, upper=Inf, k=k)
		}
	
	
		CGM.prior<- rep(0, k+1)
		for (i in 0:k){
			CGM.prior[i+1]<- temp.fun(i)$value
		}
		return(CGM.prior)				
	}
	
	if (type == "HB"){
		temp.fun2<- function(ki, k){
			f<- function(p, ki, k) {
				l1<- log(sqrt(pi))+pnorm(-sqrt(-2*log(1-p)), log=T)-log(1-p)-.5*log(-log(1-p))
				l2<- ki*log(p)+(k-ki)*log(1-p)
				exp(l1+l2)
			}
			integrate(f, lower=0, upper=1, ki=ki, k=k)$value
		}

		HB<- sapply(0:k, temp.fun2, k=k)
		return(HB)		
	}	
	
	if (type == "Harmonic"){
		const<- sum((1+0:k)^(-1))
		Harm<- (1+0:k)^(-1)/(choose(k, 0:k)*const)
		return(Harm)
	
	}
	
	if (type == "Beta(1,2)")
		Be1.2<- 2*exp(-lgamma(k+3)+lgamma(1+(0:k))+lgamma(k+2-(0:k)))
		return(Be1.2)
}

