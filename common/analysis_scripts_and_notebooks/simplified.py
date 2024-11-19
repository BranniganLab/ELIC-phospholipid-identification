def getRelProb(alpha, beta, xa, xb, stateTable, RT):
    with np.errstate(divide='ignore'):
        prob = (xa/xb) * np.exp(-stateTable.loc[beta, alpha]/RT)

    return prob

def getpa(alpha, beta, gamma, xa, xb, xg, stateTable, RT):
    pba = getRelProb(beta, alpha, xb, xa, stateTable, RT)
    pga = getRelProb(gamma, alpha, xg, xa, stateTable, RT)

    pa = 1/(1+pba+pga)
    
    return pa


def getfa(alpha, beta, gamma, xa, xb, xg, stateTable, RT):
    pa = getpa(alpha, beta, gamma, xa, xb, xg, stateTable, RT)
    pb = getpa(beta, alpha, gamma, xb, xa, xg, stateTable, RT)
    pg = getpa(gamma, beta, alpha, xg, xb, xa, stateTable, RT)
    
    fa = pa/(pa+pb+pg)
    
    return fa