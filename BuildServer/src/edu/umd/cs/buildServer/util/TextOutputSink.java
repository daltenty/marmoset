/**
 * Marmoset: a student project snapshot, submission, testing and code review
 * system developed by the Univ. of Maryland, College Park
 * 
 * Developed as part of Jaime Spacco's Ph.D. thesis work, continuing effort led
 * by William Pugh. See http://marmoset.cs.umd.edu/
 * 
 * Copyright 2005 - 2011, Univ. of Maryland
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 * 
 */

/*
 * Created on Sep 22, 2004
 */
package edu.umd.cs.buildServer.util;

/**
 * @author David Hovemeyer
 */
public class TextOutputSink {
	private StringBuffer buf;

	public TextOutputSink() {
		buf = new StringBuffer();
	}

	public synchronized void appendLine(String line) {
		buf.append(line);
		buf.append('\n');
	}

	public synchronized void append(String msg) {
		buf.append(msg);
	}

	public synchronized String getOutput() {
		return buf.toString();
	}
}
