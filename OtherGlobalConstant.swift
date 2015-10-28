//
//  OtherGlobalConstant.swift
//  RunnerApp
//
//  Created by Steven Prescott on 9/28/15.
//  Copyright (c) 2015 Steven Prescott. All rights reserved.
//

import Foundation

enum ApiResponseValue : Int
{
    case  LoginApiCalled = 0,
    RunnerListApiCalled,
    SignUpApiCalled,
    RemoveRunnerApiCalled,
    AddRunnerApiCalled,
    EditRunnerApiCalled,
    RunnerStatApiCalled,
    AddRunApiCalled,
    InitializeRunnerScreen
}