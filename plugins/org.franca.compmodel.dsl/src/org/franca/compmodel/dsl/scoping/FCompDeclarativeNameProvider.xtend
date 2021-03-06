/* Copyright (C) 2017 BMW Group
 * Author: Bernhard Hennlich (bernhard.hennlich@bmw.de)
 * Author: Manfred Bathelt (manfred.bathelt@bmw.de)
 * This Source Code Form is subject to the terms of the Eclipse Public
 * License, v. 1.0. If a copy of the EPL was not distributed with this
 * file, You can obtain one at https://www.eclipse.org/legal/epl-v10.html. 
 */
package org.franca.compmodel.dsl.scoping

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.franca.compmodel.dsl.fcomp.FCInjectedPrototype
import org.franca.compmodel.dsl.fcomp.FCPort
import org.franca.compmodel.dsl.fcomp.FCPrototype
import org.franca.compmodel.dsl.fcomp.FCPrototypeInjection
import org.franca.compmodel.dsl.fcomp.FCPrototypeInstance

//import org.franca.compmodel.dsl.FCompUtils
//import org.franca.compmodel.dsl.fcomp.FCComponent
//import org.franca.compmodel.dsl.fcomp.FCInjectedPrototype
//import org.franca.compmodel.dsl.fcomp.FCInstance
//import org.franca.compmodel.dsl.fcomp.FCModel


class FCompDeclarativeNameProvider extends DefaultDeclarativeQualifiedNameProvider {
	
	/** 
	 * Build FQN by prefixing the parent FQN to the name of the object.
	 */
	private def QualifiedName makeFQN(EObject obj, QualifiedName qualifiedNameFromConverter) {
		var EObject temp = obj
		while (temp.eContainer() !== null) {
			temp = temp.eContainer()
			val QualifiedName parentsQualifiedName = getFullyQualifiedName(temp)
			if (parentsQualifiedName !== null)
				return parentsQualifiedName.append(qualifiedNameFromConverter)
		}
		qualifiedNameFromConverter
	}
	
	/**
	 * Provide the interface name as qualified name for a port if no explicit name is given by the user.
	 */
	def QualifiedName qualifiedName(FCPort p) {
        if (p.name !== null && p.name.length > 0) 
        	return super.qualifiedName(p)
		
		val node = NodeModelUtils.getNode(p)
		val name = NodeModelUtils.getTokenText(node).split("\\s").last
		p.name = name
		val fqn = converter.toQualifiedName( name )
		fqn
    }
    
    /**
	 * Provide the component name as qualified name for a port if no explicit name is given by the user.
	 */
	def QualifiedName qualifiedName(FCPrototype pt) {
        if (pt.name !== null && pt.name.length > 0) 
        	return super.qualifiedName(pt)
		
		val node = NodeModelUtils.getNode(pt)
		val name = NodeModelUtils.getTokenText(node).split("\\s").last
		pt.name = name
		val fqn = makeFQN(pt, converter.toQualifiedName( name ))
		fqn
    }
    
    def QualifiedName qualifiedName(FCPrototypeInstance hr) {
		
		val node = NodeModelUtils.getNode(hr)
		val name = NodeModelUtils.getTokenText(node).split("\\s").last
		val fqn = makeFQN(hr, converter.toQualifiedName( name ))
		fqn		
    }
     
    def QualifiedName qualifiedName(FCPrototypeInjection pi) {
		
		val node = NodeModelUtils.getNode(pi)
		val text = NodeModelUtils.getTokenText(node)
		val name = text.split("\\s").get(3)
		pi.name = name
		val fqn = makeFQN(pi, converter.toQualifiedName( name ))
		fqn	
    }
    
    def QualifiedName qualifiedName(FCInjectedPrototype ip) {
		
		val node = NodeModelUtils.getNode(ip)
		val text = NodeModelUtils.getTokenText(node)
		val name = text.split("\\s").get(1)
		ip.name = name
		val fqn = makeFQN(ip, converter.toQualifiedName( name ))
		fqn	
    }
}
