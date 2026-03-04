<?php

namespace App\Http\Controllers\Frontend;

use App\Http\Controllers\Controller;

class InventoryPageController extends Controller
{
    public function index()
    {
        return view('inventory');
    }
}