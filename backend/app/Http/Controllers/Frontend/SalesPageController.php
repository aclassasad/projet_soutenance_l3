<?php

namespace App\Http\Controllers\Frontend;

use App\Http\Controllers\Controller;

class SalesPageController extends Controller
{
    public function index()
    {
        return view('sales');
    }
}