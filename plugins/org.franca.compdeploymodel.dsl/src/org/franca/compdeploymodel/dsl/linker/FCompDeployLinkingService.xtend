/* Copyright (C) 2017 BMW Group
 * Author: Bernhard Hennlich (bernhard.hennlich@bmw.de)
 * Author: Manfred Bathelt (manfred.bathelt@bmw.de)
 * This Source Code Form is subject to the terms of the Eclipse Public
 * License, v. 1.0. If a copy of the EPL was not distributed with this
 * file, You can obtain one at https://www.eclipse.org/legal/epl-v10.html. 
 */
package org.franca.compdeploymodel.dsl.linker

import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.linking.impl.DefaultLinkingService
import org.eclipse.xtext.linking.impl.IllegalNodeException
import org.eclipse.xtext.nodemodel.INode
import org.franca.compdeploymodel.dsl.fDeploy.FDService
import org.franca.compmodel.dsl.FCompUtils

class FCompDeployLinkingService extends DefaultLinkingService {
	
	public static final String DOMAIN ="#fdepl"
	
	public override List<EObject> getLinkedObjects(EObject context, EReference ref, INode node)
			throws IllegalNodeException {
		val List<EObject> list = super.getLinkedObjects(context, ref, node)

		switch context {
			FDService case list.isEmpty(): 
				 FCompUtils::linkInstance(node, context, DOMAIN)
			default:
				 list 		 
		}
	}
	
	
}